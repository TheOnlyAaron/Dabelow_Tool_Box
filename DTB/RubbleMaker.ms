--*****************************************************
-- Rubble_Maker_v0.10.ms
--
-- 11.19.09
--Aaron Dabelow, theonlyaaron@gmail.com
-- www.aarondabelow.com
-- Written for MAX v.9.0 and up
--*****************************************************
-- PURPOSE:
--*****************************************************
-- HISTORY:
--    - v0.10 (11.19.09):
--        (i) 1st Beta version.
--*****************************************************

--------------------------------------------------------------
-------------------- VARIABLE SETUP--------------------
--------------------------------------------------------------

closeRolloutFloater rubbleMaker

--------------------------------------------------------------
--------------RUBBLE MENU CREATION ----------------
--------------------------------------------------------------

rollout rubbleVariables "Rubble Variables"
(
	dropdownlist type_drop "Pile Type"  items:#("  Radial  ","  Square  ","  Pill  ") height:20
	groupBox sliceOptionsGroup "Slice Options" width:134 height:38 
	checkbox wallSliceBox " Wall" pos: [20,68]
	checkbox cornerSliceBox " Corner" pos: [83,68]
	groupBox rubbleOptionsGroup "Rubble Options" width:134 height:88 pos: [13,95]
	
)

--------------------------------------------------------------
------------------- RUBBLE CREATION-------------------
--------------------------------------------------------------
rollout rubbleCreate "Rubble Creation"
(
	button createRubble "Create Rubble" width: 150 height:40
	progressbar debrisProgress  pos: [7,52] width: 124 height:20
	button informationButton "?" pos: [136,52] width: 20 height:20
		on informationButton pressed do
		(rollout InformationDialog "Rubble Maker Info"
			(
			label lab1 ""
			label lab2 "Rubble Maker  v0.10"
			label lab3 "By Aaron Dabelow"
			label lab4 ""
			label lab5 "www.aarondabelow.com"
			label lab6 "theonlyaaron@gmail.com"
			label lab7 "9-17-2009"
			label lab8 ""
			)
		createDialog InformationDialog 175 150
		)
)

rubbleMaker=newrolloutfloater "Rubble Maker" 175 430 198 82
addrollout rubbleVariables rubbleMaker
addrollout rubbleCreate rubbleMaker

