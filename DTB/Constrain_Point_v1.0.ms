(
try(closeRolloutFloater ConstrainPoint)catch()
)

global positionsCheckVal = True
global rotationsCheckVal = True

rollout thefrickenrollout "Constraint Point"
(
	
	button RunScript "Constrain Point Selected" width:150 height:30 tooltip:"Launches the chosen script." pos:[7,10] --pos:[10,21]
	Checkbox PositionCheck "Positions" pos:[8,45] tristate:2
	Checkbox rotationCheck "Rotations" pos:[78,45] tristate:2
	
	on PositionCheck changed positionsCheckVal do
	(
	If positionsCheckVal != true then (positionsCheckVal = false)
	else (positionsCheckVal = true)
	print ("constrain Postitions:" + positionsCheckVal as string)
	)	

	on rotationCheck changed rotationsCheckVal do
	(
	If rotationsCheckVal != true then (rotationsCheckVal = false)
	else (rotationsCheckVal = true)
	print ("constrain Rotations:" + rotationsCheckVal as string)
	)	

	on RunScript pressed do
	(
		for i in 1 to selection.count do
		(
			nodeName = selection[i].name as string + "_DRIVER" 
			nodePoint = point centermarker:off axistripod:off cross:on Box:on size: 3 name:nodeName
			nodePoint.wirecolor = color 169 0 0
			nodePoint.transform = selection[i].transform
			
			selection[i].rotation.controller = rotation_list () 
			selection[i].rotation.controller.Available.controller = orientation_Constraint () nodePoint
			selection[i].rotation.controller.orientation_Constraint.constraints.appendTarget nodePoint 100
			selection[i].rotation.controller.Available.controller = euler_xyz () 
			selection[i].rotation.controller.SetActive 3

			selection[i].position.controller = position_list () 
			selection[i].position.controller.Available.controller = position_Constraint () nodePoint
			selection[i].position.controller.position_Constraint.constraints.appendTarget nodePoint 100
			selection[i].position.controller.Available.controller = Position_XYZ () 
			selection[i].position.controller.SetActive 3
			--selection[i].parent = nodePoint
		)			
	)
	
------------------------------------------------	
	hyperLink aaronDabelow "© 2010  Aaron Dabelow" address:"http://aarondabelow.com/" tooltip:"www.aarondabelow.com" pos:[9,73] 
	button informationButton "?" width: 20 height:20  tooltip:"Information"pos: [136,68]
	on informationButton pressed do
	(
	try(closerolloutfloater InformationDialog)catch()
	rollout InformationDialog "Script Runner Info"
		(
		--bitmap dtbHeadder fileName:"Scripts\DTB\dtb_headder.gif" width: 164 height:47 align:#center
		label labSpace1 ""
		hyperLink DTBLink "Dabelow Tool Box  v1.0  Help" address:"http://www.aarondabelow.com/pages/dabelow_tool_box.html" align:#center
		label lab1 ""
		hyperLink aaronDabelow "Aaron Dabelow" address:"http://aarondabelow.com/" align:#center
		label lab6 "theonlyaaron@gmail.com"
		label labSpace2 ""
		)
	createDialog InformationDialog 175 120
	)
)
ConstrainPoint=newrolloutfloater "Constrain Point" 175 123 198 82
addrollout thefrickenrollout ConstrainPoint
