--*****************************************************
-- AE_Position_Exporter.ms
--
-- 12.25.09
--Aaron Dabelow, theonlyaaron@gmail.com
-- www.aarondabelow.com
-- Written for MAX v.9.0 and up
--*****************************************************
-- PURPOSE:
--		Export static and animated positions from 3ds Max
--		to Adobe After Effects keyframe data to be used
--		for compositing.
--*****************************************************
-- HISTORY:
--    - v1.0 (12.25.09):
--        (i) 1st version.
--*****************************************************

--------------------------------------------------------------
-------------------- VARIABLE SETUP--------------------
--------------------------------------------------------------

try(closeRolloutFloater ColorThinger)catch()

(
	
global ColorRed = color 255 0 0
global ColorGreen = color 0 255 0
global ColorBlue = color 0 0 255
global ColorOrange = color 255 169 0
global ColorRight = color 169 0 0
global ColorLeft = color 0 112 255

	
global BlueButtonBM = bitmap 50 50 color:ColorBlue
global GreenButtonBM = bitmap 50 50 color:ColorGreen
global RedButtonBM = bitmap 50 50 color:ColorRed
global OrangeButtonBM = bitmap 50 50 color:ColorOrange
global RightButtonBM = bitmap 50 50 color:ColorRight
global LeftButtonBM = bitmap 50 50 color:ColorLeft


)

--------------------------------------------------------------
----------------STATIC POS ROLLOUT------------------
--------------------------------------------------------------

rollout ColorThingerPresetRollout "Color Presets"
(
	button autoColorButton " Auto Color " width: 135 height:20 --pos: [13,22] tooltip: "Copy selected objects position data to your clipboard to be pasted into After Effects."
	--button BlueButton " Save Position as .txt " width: 135 height:20 color:blue --pos: [13,46] tooltip: "Save selected objects position data as a .txt file to be copied into After Effects."
	imgtag redButton width:30 height:30 bitmap:redButtonBM pos:[15,33]
	imgtag greenButton width:30 height:30 bitmap:GreenButtonBM pos:[50,33]
	imgtag blueButton width:30 height:30 bitmap:BlueButtonBM pos:[85,33]
	imgtag OrangeButton width:30 height:30 bitmap:OrangeButtonBM pos:[120,33]
	imgtag RightButton width:65 height:30 bitmap:RightButtonBM pos:[85,68]
	imgtag LeftButton width:65 height:30 bitmap:LeftButtonBM pos:[15,68]
	
	label RightLabel "Right "pos:[85,68]
	label LeftLabel "Left "pos:[15,68]
	
	on redButton mousedown do($.wirecolor = ColorRed)
	on greenButton mousedown do($.wirecolor = ColorGreen)
	on blueButton mousedown do($.wirecolor = ColorBlue)
	on OrangeButton mousedown do($.wirecolor = ColorOrange)
	on RightButton mousedown do($.wirecolor = ColorRight)
	on LeftButton mousedown do($.wirecolor = ColorLeft)
	
	on autoColorButton pressed do(messagebox "Select Object(s)")
)



--------------------------------------------------------------
--------------FLOATER CONSTRUCTION----------------
--------------------------------------------------------------

ColorThinger = newrolloutfloater "ColorThinger" 175 135 198 82
addrollout ColorThingerPresetRollout ColorThinger