(
try(closeRolloutFloater RivetPoint)catch()
)

Global PickedSurface
pickedSurface = undefined
PickedSurfaceArray = #()
DecalArray = #()

rollout thefrickenrollout "Rivet Point"
(
	GroupBox GrpBox1 "Surface" width: 140 height:52
	Pickbutton RivetPointSelection "Select Rivet Surface" width:125 height:30 tooltip:"The skinned surface you are riveting to." pos:[20,22]
	GroupBox GrpBox2 "Rivet" width: 140 height:115 pos:[13,60]
	Button RivetPointMaker "Create Rivit Point" width:125 height:30 tooltip:"Click on rivet surface" pos:[20,75] 
	Checkbox ConvertSkinCheck "Convert To Skin" pos:[20,110] tristate:1
	Checkbox ControlerPointCheck "Make Control Point" tristate:1  pos:[20,130]
	Spinner DecalSizeSpinner range:[1,20,3] width:40 type:#integer pos:[19,150]
	label label1 "Size Offset" pos:[65,151]
	GroupBox GrpBox3 "Group Rivet to Skin" width: 140 height:95 pos:[13,178]
	Button RivetGroupMaker "Rivet Selection" width:125 height:30 tooltip:"Grab Junk to Rivet" pos:[20,195] 
	Checkbox ControlerPointCheckB "Make Control Point" tristate:1  pos:[20,230]
	Spinner DecalSizeSpinnerB range:[1,20,3] width:40 type:#integer pos:[19,250]
	label label2 "Size Offset" pos:[65,251]
	
	on  RivetGroupMaker pressed do 
	(
	if pickedSurface == undefined then (messagebox "You must select a valid surface!") else
		(
		if selection.count == 0 then (messagebox "Select something to attach, silly!") else
			(
			DecalArray = #()
			newDecal = Plane length:DecalSizeSpinnerB.value width:DecalSizeSpinnerB.value pos:[0,0,0] lengthsegs:1 widthsegs:1 renderable:off
			newDecal.renderable = off
				
			for i in 1 to selection.count do
				(
				NewNodeSizeB = (DecalSizeSpinnerB.value*2)
				newNode = point wirecolor:red centermarker: off axistripod: off cross: on cross: on Box: off size: NewNodeSizeB
				newNode.transform = selection[i].transform
				NewDecalIteration = copy newdecal
				NewDecalIteration.transform = newNode.transform
				newDecalIteration.renderable = off
				newDecalIteration.wirecolor = [255,169,0]
				
				addmodifier NewDecalIteration (Skin_Wrap weightAllVerts:on meshlist:PickedSurfaceArray) 
				
				newNode.pos.controller = position_list ()
				farts = newNode.pos.controller.Available.controller = Attachment node: NewDecalIteration coord: [0,.5] face:1
				AttachCtrl.addNewKey farts 1
				
				join DecalArray #(newDecalIteration)
				
				if ControlerPointCheckB.checked == true then 
					(
					newCtrlNode = point wirecolor:Green centermarker: off axistripod: off cross: off cross: off Box: on size: NewNodeSizeB
					newCtrlNode.transform = selection[i].transform
					newCtrlNode.Parent = newNode
					selection[i].parent = newCtrlNode
					newCtrlNode.setSkinPose()
					)else(selection[i].parent = newNode)
				)
			delete newDecal
			select decalArray
			)
		)
	)
	
	on RivetPointSelection picked PickedSurfaceVar do
	(
		PickedSurfaceArray = #()
		PickedSurface = PickedSurfaceVar
		join PickedSurfaceArray #(PickedSurface)
		if classof PickedSurface.modifiers[1] == skin then
			(
			RivetPointSelection.text = PickedSurface.name
			print PickedSurface
			) else (messagebox "Top Modifier must be a 'Skin' Modifier")
	)
	
	------------------------------ allow non skinnned surfaces
	
	on RivetPointMaker pressed do
	(
		if pickedSurface == undefined then (messagebox "you must select a valid surface") else
			(
			try
				(
				maxOps.autoGrid = true
				newNodeArray = startObjectCreation point returnNewNodes:#first 
				
				disableSceneRedraw ()
					
				max modify mode
				clearSelection()
				NewNodeSize = (DecalSizeSpinner.value*2)
				newNode = newNodeArray[1]
				newNode.wirecolor = red
				newNode.centermarker = off
				newNode.axistripod = off
				newNode.cross = on
				newNode.Box = off
				newNode.size = NewNodeSize
				print newnode.size
				newDecal = Plane length:DecalSizeSpinner.value width:DecalSizeSpinner.value pos:[0,0,0] lengthsegs:1 widthsegs:1  isSelected:on renderable: off
				newDecal.transform = newNode.transform
				newDecal.wirecolor = [255,169,0]
				select newDecal
				
				macros.run "Modifier Stack" "Convert_to_Poly"
				subobjectLevel = 2
				$.EditablePoly.SetSelection #Edge #{2}
				$.EditablePoly.collapse #Edge
				subobjectLevel = 0
				
				modPanel.addModToSelection (Skin_Wrap ()) ui:on
				newDecal.modifiers[#Skin_Wrap].weightAllVerts = on
				newDecal.modifiers[#Skin_Wrap].meshlist = PickedSurfaceArray
				
				newNode.pos.controller = position_list ()
				farts = newNode.pos.controller.Available.controller = Attachment node: newDecal coord: [.5,0] face:1
				AttachCtrl.addNewKey farts 1
				
				------------------------------ allow non skinnned surfaces
				
				if convertSkinCheck.checked == true then
					(
					newDecal.modifiers[1].meshDeformOps.convertToSkin true
					deleteModifier newDecal 2
					)
				else ()
							
				if ControlerPointCheck.checked == true then
					(
					NewCtrlNodeSize = (DecalSizeSpinner.value*3)
					newControlerNode = point centermarker:off axistripod:off cross:off Box:on wirecolor:green size:NewCtrlNodeSize
					newControlerNode.transform = newNode.transform
					newControlerNode.parent = newNode
					newCOntrolerNode.setSkinPose()

					)			
				else ()
			)catch(messagebox "Something strange happened, try agian")
		enableSceneRedraw ()
		)
	)
	hyperLink aaronDabelow "© 2011  Aaron Dabelow" address:"http://aarondabelow.com/" tooltip:"www.aarondabelow.com" pos:[9,280] 
	button informationButton "?" width: 20 height:20  tooltip:"Information"pos: [133,276]
	on informationButton pressed do
	(
	try(closerolloutfloater InformationDialog)catch()
	rollout InformationDialog "Rivet Point Info"
		(
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

RivetPoint = newrolloutfloater "Rivet Point" 175 332 198 82
addrollout thefrickenrollout RivetPoint