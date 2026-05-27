local self_ID = "AH-1Z"

local plugin_binaries =
{
    "AH1Z_FM",
}

declare_plugin(self_ID,
{
    installed    = true,
    dirName      = current_mod_path,
    displayName  = _("AH-1Z"),
    fileMenuName = _("AH-1Z"),
    update_id    = "AH-1Z",
    version      = "0.0.6",
    state        = "installed",
    info         = _("Fresh AH-1Z development aircraft."),
    encyclopedia_path = current_mod_path .. "/Encyclopedia",
    binaries     = plugin_binaries,

    InputProfiles =
    {
        ["AH-1Z"] = current_mod_path .. "/Input/AH-1Z",
    },

    Skins =
    {
        { name = _("AH-1Z"), dir = "Theme", },
    },

    Missions =
    {
        { name = _("AH-1Z"), dir = "Missions", },
    },

    LogBook =
    {
        { name = _("AH-1Z"), type = "AH-1Z", },
    },

    Options =
    {
        {
            name   = _("AH-1Z"),
            nameId = "AH-1Z",
            dir    = "Options",
            CLSID  = "{AH1Z options}",
        },
    },
})

mount_vfs_model_path(current_mod_path .. "/Shapes")
mount_vfs_model_path(current_mod_path .. "/Cockpit/Shape")
mount_vfs_liveries_path(current_mod_path .. "/Liveries")

mount_vfs_texture_path(current_mod_path .. "/Theme/ME")
mount_vfs_texture_path(current_mod_path .. "/Textures")
mount_vfs_texture_path(current_mod_path .. "/Shapes/Textures")
mount_vfs_texture_path(current_mod_path .. "/Cockpit/IndicatorTextures")

dofile(current_mod_path .. "/AH-1Z.lua")
dofile(current_mod_path .. "/Views.lua")
make_view_settings("AH-1Z", ViewSettings, SnapViews)

local cfg_path = current_mod_path .. "/FM/AH1Z_config.lua"
dofile(cfg_path)

local AH1Z_FM_Table =
{
    [1] = self_ID,
    [2] = "AH1Z_FM",
    config_path = cfg_path,
}

local fm_cfg = AH1Z_FM or SH3SeaKing
if fm_cfg then
    AH1Z_FM_Table.center_of_mass = fm_cfg.center_of_mass
    AH1Z_FM_Table.moment_of_inertia = fm_cfg.moment_of_inertia
    AH1Z_FM_Table.suspension = fm_cfg.suspension
    AH1Z_FM_Table.disable_built_in_oxygen_system = fm_cfg.disable_built_in_oxygen_system
end

make_flyable("AH-1Z", current_mod_path .. "/Cockpit/Scripts/", AH1Z_FM_Table, current_mod_path .. "/comm.lua")

plugin_done()
