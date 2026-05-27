#!/usr/bin/env python3
"""
AH-1Z Cockpit ALBD Texture Painter
===================================
Lifts the flat carbon-black cockpit interior ALBD textures into a
dimensional dark charcoal look matching real AH-1Z reference photos:

  - Dark charcoal base with cool undertone (not pure black)
  - Per-panel subtle tint variation
  - Large-scale ambient gradient (overhead areas slightly lighter)
  - Medium-frequency panel finish variation
  - Fine surface grain
  - Edge shadow/highlight enhancement (baked fake AO)

Usage:
  python paint_cockpit_albd.py --preview        # INT_01 only -> PNG, no DDS write
  python paint_cockpit_albd.py --all            # all 17 panels, writes DDS
  python paint_cockpit_albd.py --panel 5        # single panel, writes DDS
  python paint_cockpit_albd.py --all --dry-run  # show what would run, no changes
"""

import argparse
import subprocess
import shutil
import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageFilter

# ── Paths ────────────────────────────────────────────────────────────────────

TEXCONV = Path(
    r"C:\Users\mac92.LEGION\AppData\Local\Microsoft\WinGet\Packages"
    r"\Microsoft.DirectXTex.Texconv_Microsoft.Winget.Source_8wekyb3d8bbwe\texconv.exe"
)
TEXTURES = Path(r"C:\Users\mac92.LEGION\Saved Games\DCS.openbeta\Mods\aircraft\AH-1Z\Textures")
BACKUP   = Path(r"C:\Users\mac92.LEGION\Saved Games\DCS.openbeta\Mods\aircraft\AH-1Z\backup_cockpit_paint_albd")
WORK     = Path(r"C:\Users\mac92.LEGION\Saved Games\DCS.openbeta\Mods\aircraft\AH-1Z\_paint_work")
PREVIEW  = WORK / "preview"

# ── Color palette (from reference photos) ────────────────────────────────────
#
#   All values 0-255 float.  The real cockpit is a very dark charcoal with a
#   barely perceptible cool (blue-gray) undertone.  Highlights on raised edges
#   are only about 2x brighter than the base — the finish is very matte.
#
SHADOW_RGB    = np.array([ 12.0,  12.0,  14.0])   # deep recesses / panel gaps
BASE_RGB      = np.array([ 30.0,  31.0,  35.0])   # flat panel face (charcoal)
HIGHLIGHT_RGB = np.array([ 56.0,  58.0,  63.0])   # raised edge catch

# ── Per-panel tint offsets ────────────────────────────────────────────────────
# Small RGB deltas give each panel a slightly different finish character,
# matching the subtle variation visible in real photos.
PANEL_TINT = {
     1: np.array([ 0.0,  0.0,  3.0]),
     2: np.array([ 2.0,  1.0,  0.0]),
     3: np.array([ 0.0,  1.0,  1.0]),
     4: np.array([-1.0,  0.0,  3.0]),
     5: np.array([ 1.0,  1.0,  1.0]),
     6: np.array([ 0.0,  0.0,  0.0]),
     7: np.array([ 2.0,  2.0,  1.0]),
     8: np.array([ 0.0,  1.0,  2.0]),
     9: np.array([-1.0, -1.0,  0.0]),
    10: np.array([ 1.0,  0.0,  2.0]),
    11: np.array([ 0.0,  2.0,  2.0]),
    12: np.array([ 1.0,  1.0,  0.0]),
    13: np.array([ 0.0,  0.0,  2.0]),
    14: np.array([ 2.0,  1.0,  2.0]),
    15: np.array([-1.0,  0.0,  1.0]),
    16: np.array([ 0.0,  1.0,  0.0]),
    17: np.array([ 1.0,  0.0,  0.0]),
}

# ── Noise helpers ─────────────────────────────────────────────────────────────

def smooth_noise(shape, scale, rng):
    """Low-frequency noise: small grid upsampled to shape. Returns [-1, 1]."""
    h, w = shape
    grid_h = max(2, h // scale)
    grid_w = max(2, w // scale)
    small = rng.random((grid_h, grid_w)).astype(np.float32) * 2 - 1
    pil = Image.fromarray(((small + 1) * 127.5).clip(0, 255).astype(np.uint8), mode='L')
    pil = pil.resize((w, h), Image.BICUBIC)
    result = (np.array(pil, dtype=np.float32) / 127.5) - 1.0
    return result


def layered_noise(shape, rng, octaves=((512, 1.0), (128, 0.4), (32, 0.15))):
    """Sum of smooth_noise octaves. Returns [-1, 1] (approximately)."""
    result = np.zeros(shape, dtype=np.float32)
    total_weight = sum(w for _, w in octaves)
    for scale, weight in octaves:
        result += smooth_noise(shape, scale, rng) * weight
    return result / total_weight


# ── Core processing ───────────────────────────────────────────────────────────

def process_albd(png_path: Path, panel_num: int, rng: np.random.Generator) -> np.ndarray:
    """
    Load existing ALBD PNG, apply charcoal paint treatment, return RGB uint8 array.
    """
    img = Image.open(png_path).convert('RGB')
    orig = np.array(img, dtype=np.float32)  # H x W x 3, range [0, 255]
    H, W = orig.shape[:2]

    # ── 1. Extract existing detail as a luminance guide (0-1) ──────────────────
    #   The original is near-black but has faint baked detail (panel lines etc.).
    #   We amplify this to keep whatever UV-mapped structure exists.
    lum = orig.mean(axis=2)                         # 0-255
    lum_max = max(lum.max(), 1.0)
    detail = (lum / lum_max) ** 0.6                 # gamma lift — boosts faint detail
    #   detail is now 0-1, where 0 = deepest black, 1 = brightest existing pixel

    # ── 2. Map detail to charcoal range ────────────────────────────────────────
    #   Shadow pixels stay near SHADOW_RGB; bright detail maps to HIGHLIGHT_RGB.
    shadow    = SHADOW_RGB    + PANEL_TINT.get(panel_num, np.zeros(3))
    base      = BASE_RGB      + PANEL_TINT.get(panel_num, np.zeros(3))
    highlight = HIGHLIGHT_RGB + PANEL_TINT.get(panel_num, np.zeros(3))

    # Interpolate: detail 0 → shadow, 0.4 → base, 1.0 → highlight
    t = detail[..., np.newaxis]                     # H x W x 1
    charcoal = np.where(
        t < 0.4,
        shadow    + (base - shadow)    * (t / 0.4),
        base      + (highlight - base) * ((t - 0.4) / 0.6)
    )  # H x W x 3, float

    # ── 3. Large-scale ambient gradient ────────────────────────────────────────
    #   Top rows of texture get a very faint brightness boost (panels nearer the
    #   canopy catch more ambient; lower panels are deeper in shadow).
    #   Amplitude: ±4 luminance units — just enough to read as depth.
    y_grad = np.linspace(4.0, -4.0, H, dtype=np.float32)[:, np.newaxis]  # H x 1
    charcoal += y_grad  # broadcast across W and channels

    # ── 4. Medium panel-finish variation (layered noise) ───────────────────────
    #   Simulates slightly uneven matte paint within a panel — amplitude ±6.
    mid_noise = layered_noise((H, W), rng, octaves=((512, 1.0), (128, 0.5)))
    charcoal += mid_noise[..., np.newaxis] * 6.0

    # ── 5. Fine surface grain ──────────────────────────────────────────────────
    grain = rng.normal(0.0, 3.5, (H, W)).astype(np.float32)
    charcoal += grain[..., np.newaxis]

    # ── 6. Edge shadow / highlight (baked fake AO) ─────────────────────────────
    #   Find edges in the detail map.  One side of each edge gets slightly
    #   darkened (shadow), the other slightly brightened (highlight catch).
    #   This gives buttons and panel edges a 3D look in the albedo alone.
    detail_img  = Image.fromarray((detail * 255).clip(0, 255).astype(np.uint8), mode='L')
    edge_img    = detail_img.filter(ImageFilter.FIND_EDGES)
    edge        = np.array(edge_img, dtype=np.float32) / 255.0   # 0-1 edge strength

    # Shift edge map by a few pixels to get the shadow side
    shadow_side = np.roll(edge, shift=3, axis=0) + np.roll(edge, shift=3, axis=1)
    shadow_side = np.clip(shadow_side, 0, 1)
    # Highlight side is the opposite
    highlight_side = np.roll(edge, shift=-2, axis=0) + np.roll(edge, shift=-2, axis=1)
    highlight_side = np.clip(highlight_side, 0, 1)

    charcoal -= shadow_side[..., np.newaxis]    * 10.0
    charcoal += highlight_side[..., np.newaxis] *  7.0

    # ── 7. Clip and return ─────────────────────────────────────────────────────
    result = np.clip(charcoal, 0, 255).astype(np.uint8)
    return result


# ── DDS conversion helpers ────────────────────────────────────────────────────

def dds_to_png(dds_path: Path, out_dir: Path) -> Path:
    """Convert a DDS file to PNG in out_dir using texconv. Returns PNG path."""
    out_dir.mkdir(parents=True, exist_ok=True)
    cmd = [str(TEXCONV), "-y", "-ft", "png", "-o", str(out_dir), str(dds_path)]
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0:
        raise RuntimeError(f"texconv failed converting {dds_path.name}:\n{r.stderr}")
    return out_dir / dds_path.with_suffix(".png").name


def png_to_dds(png_path: Path, out_dir: Path) -> Path:
    """Convert a PNG back to DDS BC1_UNORM (matching original format). Returns DDS path."""
    out_dir.mkdir(parents=True, exist_ok=True)
    cmd = [
        str(TEXCONV),
        "-y",
        "-f", "BC1_UNORM",
        "-m", "0",           # generate all mips
        "-ft", "dds",
        "-o", str(out_dir),
        str(png_path),
    ]
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0:
        raise RuntimeError(f"texconv failed converting {png_path.name} to DDS:\n{r.stderr}")
    return out_dir / png_path.with_suffix(".dds").name


# ── Main ──────────────────────────────────────────────────────────────────────

def process_panel(panel_num: int, dry_run: bool, preview_mode: bool):
    name = f"BELL_AH_1Z_INT_{panel_num:02d}_ALBD"
    dds_src = TEXTURES / f"{name}.dds"

    if not dds_src.exists():
        print(f"  [SKIP] {name}.dds not found")
        return

    print(f"  [{panel_num:02d}] {name}.dds", end="", flush=True)

    if dry_run:
        print("  (dry-run, skipped)")
        return

    rng = np.random.default_rng(seed=panel_num * 137)

    # Convert DDS → PNG
    png_src = dds_to_png(dds_src, WORK)
    print(f" -> PNG", end="", flush=True)

    # Paint
    result_arr = process_albd(png_src, panel_num, rng)
    print(f" -> paint", end="", flush=True)

    if preview_mode:
        # Save preview PNG only, no DDS write
        preview_path = PREVIEW / f"{name}_PAINTED.png"
        PREVIEW.mkdir(parents=True, exist_ok=True)
        Image.fromarray(result_arr, 'RGB').save(preview_path)
        # Also save a 512-px thumbnail for easy viewing
        thumb = Image.fromarray(result_arr, 'RGB').resize((512, 512), Image.LANCZOS)
        thumb.save(PREVIEW / f"{name}_thumb.png")
        print(f" -> preview saved: {preview_path}")
        return

    # Backup original DDS
    BACKUP.mkdir(parents=True, exist_ok=True)
    backup_dds = BACKUP / f"{name}.dds"
    if not backup_dds.exists():
        shutil.copy2(dds_src, backup_dds)
        print(f" -> backed up", end="", flush=True)

    # Save painted PNG to work dir
    painted_png = WORK / f"{name}_PAINTED.png"
    Image.fromarray(result_arr, 'RGB').save(painted_png)

    # Convert PNG → DDS
    new_dds = png_to_dds(painted_png, WORK)
    print(f" -> DDS", end="", flush=True)

    # Replace original
    shutil.copy2(new_dds, dds_src)
    print(f" -> DONE")


def main():
    parser = argparse.ArgumentParser(description="AH-1Z Cockpit ALBD Painter")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--preview", action="store_true",
                       help="Process INT_01 only, save PNG preview (no DDS written)")
    group.add_argument("--all",     action="store_true",
                       help="Process all 17 interior panels")
    group.add_argument("--panel",   type=int, metavar="N",
                       help="Process a single panel number (1-17)")
    parser.add_argument("--dry-run", action="store_true",
                        help="List what would be processed, make no changes")
    args = parser.parse_args()

    if not TEXCONV.exists():
        sys.exit(f"ERROR: texconv not found at {TEXCONV}")

    WORK.mkdir(parents=True, exist_ok=True)

    if args.preview:
        print("=== PREVIEW MODE: INT_01 only, PNG output, no DDS changes ===")
        process_panel(1, dry_run=False, preview_mode=True)
        print(f"\nPreview saved to: {PREVIEW}")

    elif args.all:
        label = "DRY RUN" if args.dry_run else "PAINTING ALL 17 PANELS"
        print(f"=== {label} ===")
        for n in range(1, 18):
            process_panel(n, dry_run=args.dry_run, preview_mode=False)
        if not args.dry_run:
            print(f"\nBackups in: {BACKUP}")

    elif args.panel is not None:
        if not 1 <= args.panel <= 17:
            sys.exit("ERROR: --panel must be 1-17")
        print(f"=== PAINTING PANEL {args.panel} ===")
        process_panel(args.panel, dry_run=args.dry_run, preview_mode=False)


if __name__ == "__main__":
    main()
