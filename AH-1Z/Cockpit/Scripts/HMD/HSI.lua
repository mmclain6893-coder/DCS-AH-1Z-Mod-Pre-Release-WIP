
-- HUD Center
local Pitch_Ladder_center			= CreateElement "ceSimple"
Pitch_Ladder_center.name			= "Pitch_Ladder_center"
Pitch_Ladder_center.init_pos		= vth_base_init_pos
Pitch_Ladder_center.element_params 	= {"D_ROLL", "D_PITCH", "UFC1HUDBRT"}
Pitch_Ladder_center.controllers		= {{"rotate_using_parameter" ,0, 1}, {"move_up_down_using_parameter", 1, -0.60 }, {"opacity_using_parameter",2}}
AddHUDElement(Pitch_Ladder_center)

-- Pitch Ladder
local  pl_p90_line			     = create_vth_textured_box( 19, 589, 439, 619) -- ( 10, 600, 440, 625)
pl_p90_line.name			    = "pl_p90_line"
pl_p90_line.init_pos		    = {0,(Pitch_Ladder_offset * 18)}
pl_p90_line.element_params  	= {"UFC1HUDBRT"}
pl_p90_line.controllers     	= {{"opacity_using_parameter",0}}
pl_p90_line.parent_element	    = Pitch_Ladder_center.name
AddHUDElement(pl_p90_line)

local  pl_p85_line                = create_vth_textured_box( 13, 24, 354, 38) -- ( 8, 25, 352, 38)
pl_p85_line.name 	                = "pl_p85_line"
pl_p85_line.init_pos              = {0,(Pitch_Ladder_offset * 17)} -- {0, -2, 0}
pl_p85_line.element_params  		= {"UFC1HUDBRT"}
pl_p85_line.controllers     		= {{"opacity_using_parameter",0}}
pl_p85_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_p85_line)

local  pl_p80_line                = create_vth_textured_box( 19, 559, 439, 589) -- ( 10, 570, 440, 595)
pl_p80_line.name 	                = "pl_p80_line"
pl_p80_line.init_pos              = {0,(Pitch_Ladder_offset * 16)}
pl_p80_line.element_params  		= {"UFC1HUDBRT"}
pl_p80_line.controllers     		= {{"opacity_using_parameter",0}}
pl_p80_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_p80_line)

local  pl_p75_line			          = create_vth_textured_box( 13, 24, 354, 38) -- ( 8, 25, 352, 38)
pl_p75_line.name			            = "pl_p75_line"
pl_p75_line.init_pos		          = {0,(Pitch_Ladder_offset * 15)} -- {0, -2, 0}
pl_p75_line.element_params  		= {"UFC1HUDBRT"}
pl_p75_line.controllers     		= {{"opacity_using_parameter",0}}
pl_p75_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_p75_line)

local  pl_p70_line			          = create_vth_textured_box( 19, 529, 439, 559) -- ( 10, 535, 440, 560)
pl_p70_line.name			            = "pl_p70_line"
pl_p70_line.init_pos		          = {0,(Pitch_Ladder_offset * 14)}
pl_p70_line.element_params  		= {"UFC1HUDBRT"}
pl_p70_line.controllers     		= {{"opacity_using_parameter",0}}
pl_p70_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_p70_line)

local  pl_p65_line			          = create_vth_textured_box( 13, 24, 354, 38) -- ( 8, 25, 352, 38)
pl_p65_line.name			            = "pl_p65_line"
pl_p65_line.init_pos		          = {0,(Pitch_Ladder_offset * 13)}-- {0, -2, 0}
pl_p65_line.element_params  		= {"UFC1HUDBRT"}
pl_p65_line.controllers     		= {{"opacity_using_parameter",0}}
pl_p65_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_p65_line)

local  pl_p60_line			          = create_vth_textured_box( 19, 499, 439, 529) -- ( 10, 505, 440, 530)
pl_p60_line.name			            = "pl_p60_line"
pl_p60_line.element_params  		= {"UFC1HUDBRT"}
pl_p60_line.controllers     		= {{"opacity_using_parameter",0}}
pl_p60_line.init_pos		          = {0,(Pitch_Ladder_offset * 12)}
pl_p60_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_p60_line)

local  pl_p55_line			          = create_vth_textured_box( 13, 24, 354, 38) -- ( 8, 25, 352, 38)
pl_p55_line.name			            = "pl_p55_line"
pl_p55_line.init_pos		          = {0,(Pitch_Ladder_offset * 11)} -- {0, -2, 0}
pl_p55_line.element_params  		= {"UFC1HUDBRT"}
pl_p55_line.controllers     		= {{"opacity_using_parameter",0}}
pl_p55_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_p55_line)

local  pl_p50_line			          = create_vth_textured_box( 19, 469, 439, 499) -- ( 10, 470, 440, 495)
pl_p50_line.name			            = "pl_p50_line"
pl_p50_line.init_pos		          = {0,(Pitch_Ladder_offset * 10)}
pl_p50_line.element_params  		= {"UFC1HUDBRT"}
pl_p50_line.controllers     		= {{"opacity_using_parameter",0}}
pl_p50_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_p50_line)

local  pl_p45_line			          = create_vth_textured_box( 13, 24, 354, 38) -- ( 8, 25, 352, 38)
pl_p45_line.name			            = "pl_p45_line"
pl_p45_line.element_params  		= {"UFC1HUDBRT"}
pl_p45_line.controllers     		= {{"opacity_using_parameter",0}}
pl_p45_line.init_pos		          = {0,(Pitch_Ladder_offset * 9)} -- {0, -2, 0}
pl_p45_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_p45_line)

local  pl_p40_line			          = create_vth_textured_box( 19, 439, 439, 469) -- ( 10, 440, 440, 465)
pl_p40_line.name			            = "pl_p40_line"
pl_p40_line.init_pos		          = {0,(Pitch_Ladder_offset * 8)}
pl_p40_line.element_params  		= {"UFC1HUDBRT"}
pl_p40_line.controllers     		= {{"opacity_using_parameter",0}}
pl_p40_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_p40_line)

local  pl_p35_line			          = create_vth_textured_box( 13, 24, 354, 38) -- ( 8, 25, 352, 38)
pl_p35_line.name			            = "pl_p35_line"
pl_p35_line.init_pos		          = {0,(Pitch_Ladder_offset * 7)} -- {0, -2, 0}
pl_p35_line.element_params  		= {"UFC1HUDBRT"}
pl_p35_line.controllers     		= {{"opacity_using_parameter",0}}
pl_p35_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_p35_line)

local  pl_p30_line			          = create_vth_textured_box( 19, 409, 439, 439) -- ( 10, 410, 440, 435)
pl_p30_line.name			            = "pl_p30_line"
pl_p30_line.element_params  		= {"UFC1HUDBRT"}
pl_p30_line.controllers     		= {{"opacity_using_parameter",0}}
pl_p30_line.init_pos		          = {0,(Pitch_Ladder_offset * 6)}
pl_p30_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_p30_line)

local  pl_p25_line			          = create_vth_textured_box( 13, 24, 354, 38) -- ( 8, 25, 352, 38)
pl_p25_line.name			            = "pl_p25_line"
pl_p25_line.element_params  		= {"UFC1HUDBRT"}
pl_p25_line.controllers     		= {{"opacity_using_parameter",0}}
pl_p25_line.init_pos		         = {0,(Pitch_Ladder_offset * 5)} -- {0, -2, 0}
pl_p25_line.parent_element	      	= Pitch_Ladder_center.name
AddHUDElement(pl_p25_line)

local  pl_p20_line			          = create_vth_textured_box( 19, 379, 439, 409) -- ( 10, 380, 440, 405)
pl_p20_line.name			            = "pl_p20_line"
pl_p20_line.element_params  		= {"UFC1HUDBRT"}
pl_p20_line.controllers     		= {{"opacity_using_parameter",0}}
pl_p20_line.init_pos		          = {0,(Pitch_Ladder_offset * 4)}
pl_p20_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_p20_line)

local  pl_p15_line			          = create_vth_textured_box( 13, 24, 354, 38) -- ( 8, 25, 352, 38)
pl_p15_line.name			            = "pl_p15_line"
pl_p15_line.element_params  		= {"UFC1HUDBRT"}
pl_p15_line.controllers     		= {{"opacity_using_parameter",0}}
pl_p15_line.init_pos		          = {0,(Pitch_Ladder_offset * 3)} -- {0, -2, 0}
pl_p15_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_p15_line)

local  pl_p10_line			          = create_vth_textured_box( 19, 349, 439, 379) -- ( 10, 350, 440, 375)
pl_p10_line.name			            = "pl_p10_line"
pl_p10_line.element_params  		= {"UFC1HUDBRT"}
pl_p10_line.controllers     		= {{"opacity_using_parameter",0}}
pl_p10_line.init_pos		          = {0,(Pitch_Ladder_offset * 2)}
pl_p10_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_p10_line)

local  pl_p05_line			          = create_vth_textured_box( 13, 24, 354, 38) -- ( 8, 25, 352, 38)
pl_p05_line.name			            = "pl_p05_line"
pl_p05_line.element_params  		= {"UFC1HUDBRT"}
pl_p05_line.controllers     		= {{"opacity_using_parameter",0}}
pl_p05_line.init_pos		          = {0,Pitch_Ladder_offset } -- {0, -2, 0}
pl_p05_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_p05_line)

local  pl_hor_line			= create_vth_textured_box( 0, 5, 2048, 12)
pl_hor_line.name			= "pl_hor_line"
pl_hor_line.init_pos		= {0, 0, 0}
pl_hor_line.parent_element	= Pitch_Ladder_center.name
pl_hor_line.element_params  = {"UFC1HUDBRT"}
pl_hor_line.controllers     = {{"opacity_using_parameter",0}}
-- pl_hor_line.controllers		= {{"vis_alleg"}, {"hud_roll" ,1.0}, {"hud_elev_horiz", 0.0}}
AddHUDElement(pl_hor_line)

local  pl_m05_line			      = create_vth_textured_box( 13, 45, 354, 60) -- ( 8, 44, 352, 62)
pl_m05_line.name			      = "pl_m05_line"
pl_m05_line.element_params  		= {"UFC1HUDBRT"}
pl_m05_line.controllers     		= {{"opacity_using_parameter",0}}
pl_m05_line.init_pos		      = {0,(-1 * Pitch_Ladder_offset)} -- {0, -3, 0}
pl_m05_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_m05_line)

local  pl_m10_line			          = create_vth_textured_box( 451, 349, 871, 379) -- ( 455, 345, 870, 375)
pl_m10_line.name			            = "pl_m10_line"
pl_m10_line.element_params  		= {"UFC1HUDBRT"}
pl_m10_line.controllers     		= {{"opacity_using_parameter",0}}
pl_m10_line.init_pos		          = {0,(-1 * Pitch_Ladder_offset * 2)} --  {0, -4, 0}
pl_m10_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_m10_line)

local  pl_m15_line			          = create_vth_textured_box( 13, 45, 354, 60) -- ( 8, 44, 352, 62)
pl_m15_line.name			            = "pl_m15_line"
pl_m15_line.element_params  		= {"UFC1HUDBRT"}
pl_m15_line.controllers     		= {{"opacity_using_parameter",0}}
pl_m15_line.init_pos		          = {0,(-1 * Pitch_Ladder_offset * 3)} -- {0, -3, 0}
pl_m15_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_m15_line)

local  pl_m20_line			          = create_vth_textured_box( 451, 379, 871, 409) -- ( 455, 380, 870, 405)
pl_m20_line.name			            = "pl_m20_line"
pl_m20_line.element_params  		= {"UFC1HUDBRT"}
pl_m20_line.controllers     		= {{"opacity_using_parameter",0}}
pl_m20_line.init_pos		          = {0,(-1 * Pitch_Ladder_offset * 4)} --  {0, -4, 0}
pl_m20_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_m20_line)

local  pl_m25_line			          = create_vth_textured_box( 13, 45, 354, 60) -- ( 8, 44, 352, 62)
pl_m25_line.name			            = "pl_m25_line"
pl_m25_line.element_params  		= {"UFC1HUDBRT"}
pl_m25_line.controllers     		= {{"opacity_using_parameter",0}}
pl_m25_line.init_pos		          = {0,(-1 * Pitch_Ladder_offset * 5)} -- {0, -3, 0}
pl_m25_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_m25_line)

local  pl_m30_line			          = create_vth_textured_box( 451, 409, 871, 439) -- ( 455, 410, 870, 435)
pl_m30_line.name			            = "pl_m30_line"
pl_m30_line.element_params  		= {"UFC1HUDBRT"}
pl_m30_line.controllers     		= {{"opacity_using_parameter",0}}
pl_m30_line.init_pos		          = {0,(-1 * Pitch_Ladder_offset * 6)} --  {0, -4, 0}
pl_m30_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_m30_line)

local  pl_m35_line			          = create_vth_textured_box( 13, 45, 354, 60) -- ( 8, 44, 352, 62)
pl_m35_line.name			            = "pl_m35_line"
pl_m35_line.element_params  		= {"UFC1HUDBRT"}
pl_m35_line.controllers     		= {{"opacity_using_parameter",0}}
pl_m35_line.init_pos		          = {0,(-1 * Pitch_Ladder_offset * 7)} -- {0, -3, 0}
pl_m35_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_m35_line)

local  pl_m40_line			          = create_vth_textured_box( 451, 439, 871, 469) -- ( 455, 440, 870, 465)
pl_m40_line.name			            = "pl_m40_line"
pl_m40_line.element_params  		= {"UFC1HUDBRT"}
pl_m40_line.controllers     		= {{"opacity_using_parameter",0}}
pl_m40_line.init_pos		          = {0,(-1 * Pitch_Ladder_offset * 8)} --  {0, -4, 0}
pl_m40_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_m40_line)

local  pl_m45_line			          = create_vth_textured_box( 13, 45, 354, 60) -- ( 8, 44, 352, 62)
pl_m45_line.name			            = "pl_m45_line"
pl_m45_line.element_params  		= {"UFC1HUDBRT"}
pl_m45_line.controllers     		= {{"opacity_using_parameter",0}}
pl_m45_line.init_pos		          = {0,(-1 * Pitch_Ladder_offset * 9)} -- {0, -3, 0}
pl_m45_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_m45_line)

local  pl_m50_line			          = create_vth_textured_box( 451, 469, 871, 499) -- ( 455, 470, 870, 495)
pl_m50_line.name			            = "pl_m50_line"
pl_m50_line.element_params  		= {"UFC1HUDBRT"}
pl_m50_line.controllers     		= {{"opacity_using_parameter",0}}
pl_m50_line.init_pos		          = {0,(-1 * Pitch_Ladder_offset * 10)} --  {0, -4, 0}
pl_m50_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_m50_line)

local  pl_m55_line			          = create_vth_textured_box( 13, 45, 354, 60) -- ( 8, 44, 352, 62)
pl_m55_line.name			            = "pl_m55_line"
pl_m55_line.element_params  		= {"UFC1HUDBRT"}
pl_m55_line.controllers     		= {{"opacity_using_parameter",0}}
pl_m55_line.init_pos		          = {0,(-1 * Pitch_Ladder_offset * 11)} -- {0, -3, 0}
pl_m55_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_m55_line)

local  pl_m60_line			          = create_vth_textured_box( 451, 499, 871, 529) -- ( 455, 500, 870, 525)
pl_m60_line.name			            = "pl_m60_line"
pl_m60_line.element_params  		= {"UFC1HUDBRT"}
pl_m60_line.controllers     		= {{"opacity_using_parameter",0}}
pl_m60_line.init_pos		          = {0,(-1 * Pitch_Ladder_offset * 12)} --  {0, -4, 0}
pl_m60_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_m60_line)

local  pl_m65_line			          = create_vth_textured_box( 13, 45, 354, 60) -- ( 8, 44, 352, 62)
pl_m65_line.name			            = "pl_m65_line"
pl_m65_line.element_params  		= {"UFC1HUDBRT"}
pl_m65_line.controllers     		= {{"opacity_using_parameter",0}}
pl_m65_line.init_pos		          = {0,(-1 * Pitch_Ladder_offset * 13)} -- {0, -3, 0}
pl_m65_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_m65_line)

local  pl_m70_line			          = create_vth_textured_box( 451, 529, 871, 559) -- ( 455, 530, 870, 555)
pl_m70_line.name			            = "pl_m70_line"
pl_m70_line.element_params  		= {"UFC1HUDBRT"}
pl_m70_line.controllers     		= {{"opacity_using_parameter",0}}
pl_m70_line.init_pos		          = {0,(-1 * Pitch_Ladder_offset * 14)} --  {0, -4, 0}
pl_m70_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_m70_line)

local  pl_m75_line			          = create_vth_textured_box( 13, 45, 354, 60) -- ( 8, 44, 352, 62)
pl_m75_line.name			            = "pl_m75_line"
pl_m75_line.element_params  		= {"UFC1HUDBRT"}
pl_m75_line.controllers     		= {{"opacity_using_parameter",0}}
pl_m75_line.init_pos		          = {0,(-1 * Pitch_Ladder_offset * 15)} -- {0, -3, 0}
pl_m75_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_m75_line)

local  pl_m80_line			          = create_vth_textured_box( 451, 559, 871, 589) -- ( 455, 560, 870, 585)
pl_m80_line.name			            = "pl_m80_line"
pl_m80_line.element_params  		= {"UFC1HUDBRT"}
pl_m80_line.controllers     		= {{"opacity_using_parameter",0}}
pl_m80_line.init_pos		          = {0,(-1 * Pitch_Ladder_offset * 16)} --  {0, -4, 0}
pl_m80_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_m80_line)

local  pl_m85_line			          = create_vth_textured_box( 13, 45, 354, 60) -- ( 8, 44, 352, 62)
pl_m85_line.name			            = "pl_m85_line"
pl_m85_line.element_params  		= {"UFC1HUDBRT"}
pl_m85_line.controllers     		= {{"opacity_using_parameter",0}}
pl_m85_line.init_pos		          = {0,(-1 * Pitch_Ladder_offset * 17)} -- {0, -3, 0}
pl_m85_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_m85_line)

local  pl_m90_line			          = create_vth_textured_box( 451, 589, 871, 619) -- ( 455, 595, 870, 621)
pl_m90_line.name			            = "pl_m90_line"
pl_m90_line.element_params  		= {"UFC1HUDBRT"}
pl_m90_line.controllers     		= {{"opacity_using_parameter",0}}
pl_m90_line.init_pos		          = {0,(-1 * Pitch_Ladder_offset * 18)} --  {0, -4, 0}
pl_m90_line.parent_element	      = Pitch_Ladder_center.name
AddHUDElement(pl_m90_line)
