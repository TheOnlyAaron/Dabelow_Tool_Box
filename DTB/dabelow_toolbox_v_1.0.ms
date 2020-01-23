--*****************************************************
-- DabelowToolBox_v1.0.ms
--
-- 12.25.09
--Aaron Dabelow, theonlyaaron@gmail.com
-- www.aarondabelow.com
-- Written for MAX v.9.0 and up
--*****************************************************
-- PURPOSE:
--*****************************************************
-- HISTORY:
--    - v0.10 (12.25.09):
--        (i) 1st Beta version.
--*****************************************************
(
try(closeRolloutFloater atools)catch()
)
try
(
--*****************************************************
					-- <<< Modeling Tools >>> --
--*****************************************************
	
rollout modelingTools "Geometry Tools"
(
	groupBox grp3 "Viewport Geometry" pos:[3,3] width:156 height:45
		button randWires "Rand-Wires" pos: [83,21] width:70 height:20 tooltip:"Changes wireframes to random colors for selected objects."
		button greyIt "Grey-It" pos: [10,21] width:70 height:20 tooltip:"Adds defalt grey shader with black wireframe to selected objects."
	groupBox grp4 "Custom Primitives" pos:[3,53] width:156 height:45
		button createCyl "A-Cyl" pos: [10,70] width:70 height:20 tooltip:"Creates cylinders at two devision levels that have quad topped ends."
		button createBox "S-Box" pos: [83,70] width:70 height:20 tooltip:"Creates spheres at two devision levels that have quad based topology. They have 8 minor poles, instead of two major ones."
	
	on greyIt pressed do
	(
		try
			(
			if selection != undefined then
				(
				meditMaterials[1] = copy meditMaterials[2]
				meditMaterials[1] = Standardmaterial ()
				meditMaterials[1].name = "Default Grey"
				$.material = meditMaterials[1]
				$.wirecolor = color 0 0 0
				$.showFrozenInGray = off
				)else()
			)catch(messagebox "Select Object(s)")
		)
		
	on randWires pressed do
	(
		for i in 1 to selection.count do
			(
			selection[i].wireColor = random (color 0 0 0) (color 255 255 255)
			)
	)
	on createCyl pressed do
	(
		rcmenu createCylPopUpMenu
		(
			menuItem zoom "     Select Divisions     "
			menuItem eightSides "Eight Sides"
			menuItem twelveSides "Twelve Sides"
	
			on eightSides picked do
				(
					Cylinder smooth:on heightsegs:1 capsegs:1 sides:8 height:20 radius:10 mapcoords:on pos:[0,0,0] isSelected:on
					$.material = meditMaterials[1]
					$.wirecolor = color 0 0 0
					$.showFrozenInGray = on
					macros.run "Modifier Stack" "Convert_to_Poly"
					subobjectLevel = 4
					$.EditablePoly.SetSelection #Face #{9, 10}
					$.EditablePoly.buttonOp #Inset
					macros.run "Editable Polygon Object" "EPoly_Collapse"
					subobjectLevel = 2
					$.EditablePoly.SetSelection #Edge #{25, 27, 29, 31, 34, 36, 38, 40}
					$.EditablePoly.Remove ()
					subobjectLevel = 0			
				)
			
			on twelveSides picked do 
				(
					Cylinder smooth:on heightsegs:1 capsegs:1 sides:12 height:20 radius:10 mapcoords:on pos:[0,0,0] isSelected:on
					$.material = meditMaterials[1]
					$.wirecolor = color 0 0 0
					$.showFrozenInGray = on
					macros.run "Modifier Stack" "Convert_to_Poly"
					subobjectLevel = 4
					$.EditablePoly.SetSelection #Face #{13..14}
					$.EditablePoly.buttonOp #Inset
					macros.run "Editable Polygon Object" "EPoly_Collapse"
					subobjectLevel = 2
					$.EditablePoly.SetSelection #Edge #{37, 39, 41, 43, 45, 47, 50, 52, 54, 56, 58, 60}
					$.EditablePoly.Remove ()
					subobjectLevel = 0
				)
		)
	popUpMenu createCylPopUpMenu
	)
	
	on createBox pressed do
	(
		rcmenu createBoxPopUpMenu
		(
			menuItem zoom "     Select Divisions     "
			menuItem oneDivisions "One Division"
			menuItem twoDivisions "Two Divisions"
	
			on oneDivisions picked do
				(
					Box smooth:on length:20 width:20 height:20  mapcoords:on pos:[0,0,0] isSelected:on
					$.material = meditMaterials[1]
					modPanel.addModToSelection (meshsmooth ()) ui:on
					modPanel.addModToSelection (Spherify ()) ui:on
					$.modifiers[#MeshSmooth].iterations = 1
					$.showFrozenInGray = on
					$.wirecolor = color 0 0 0
					macros.run "Modifier Stack" "Convert_to_Poly"
					$.pivot = $.center			
				)
			
			on twoDivisions picked do 
				(
					Box smooth:on length:20 width:20 height:20  mapcoords:on pos:[0,0,0] isSelected:on
					$.material = meditMaterials[1]
					modPanel.addModToSelection (meshsmooth ()) ui:on
					modPanel.addModToSelection (Spherify ()) ui:on
					$.modifiers[#MeshSmooth].iterations = 2
					$.showFrozenInGray = on
					$.wirecolor = color 0 0 0
					macros.run "Modifier Stack" "Convert_to_Poly"
					$.pivot = $.center
				)
			)
	popUpMenu createBoxPopUpMenu
	)
	
	on zeroWelder pressed do
	(
		try
		( 
			subobjectLevel = 1
			actionMan.executeAction 0 "40021"
			max select all
			$.weldThreshold = 0.01
			$.EditablePoly.weldFlaggedVertices ()
		)catch(messagebox("Please select and editable poly object")) 	
	)
)

--*****************************************************
					-- <<< Mesh Globals >>> --
--*****************************************************

rollout meshGlobals "Mesh Globals"
(
	dropdownlist turbosmooth_drop "T-Smooth" 
	items:#("Manual","On","Off","Off in View","Off at Render") height:20 width:65 pos: [13,8]  tooltip:"Globally overrides turbosmooth modifiers."

	dropdownlist meshsmooth_drop "M-Smooth" 
	items:#("Manual","On","Off","Off in View","Off at Render") height:20 width:65  pos: [83,8] tooltip:"Globally overrides meshsmooth modifiers."
	
	dropdownlist shell_drop "Shell" 
	items:#("Manual","On","Off","Off in View","Off at Render") height:20 width:65 pos: [83,50] tooltip:"Globally overrides shell modifiers."

	dropdownlist subdivide_drop "Subdivide" 
	items:#("Manual","On","Off","Off in View","Off at Render") height:20 width:65  pos: [13,50] tooltip:"Globally overrides subdivide modifiers."
	
	on turbosmooth_drop selected i do
	(
		if i != 1 then () -- MANUAL 
		else()
		
		if i != 2 then () -- ON
		else
			(
				for i in objects do try 
				(
					i.modifiers[#Turbosmooth].enabledInViews = true
					i.modifiers[#Turbosmooth].enabled = true
				)
				catch ()
			)

		if i != 3 then () -- OFF
		else
			(
				for i in objects do try 
				(
					i.modifiers[#Turbosmooth].enabledInViews = true
					i.modifiers[#Turbosmooth].enabled = false
				)
				catch ()
			)
			
		if i != 4 then () -- OFF IN VIEWPORT
				else
			(
				for i in objects do try
				(
					i.modifiers[#Turbosmooth].enabledInViews = false
					i.modifiers[#Turbosmooth].enabled = true
					i.modifiers[#Turbosmooth].enabledInRenders = true
				)
				catch ()			
			)
			
		if i != 5 then () -- OFF IN RENDERER
				else
			(
				for i in objects do try
				(
					i.modifiers[#Turbosmooth].enabledInViews = true
					i.modifiers[#Turbosmooth].enabled = true
					i.modifiers[#Turbosmooth].enabledInRenders = false
				)
				catch ()
			)
			
	)
	on meshsmooth_drop  selected i do
	(
		if i != 1 then () -- MANUAL 
		else()
		
		if i != 2 then () -- ON
		else
			(
				for i in objects do try 
				(
					i.modifiers[#Meshsmooth].enabledInViews = true
					i.modifiers[#Meshsmooth].enabled = true
				)
				catch ()
			)

		if i != 3 then () -- OFF
		else
			(
				for i in objects do try 
				(
					i.modifiers[#Meshsmooth].enabledInViews = true
					i.modifiers[#Meshsmooth].enabled = false
				)
				catch ()
			)
			
		if i != 4 then () -- OFF IN VIEWPORT
				else
			(
				for i in objects do try
				(
					i.modifiers[#Meshsmooth].enabledInViews = false
					i.modifiers[#Meshsmooth].enabled = true
					i.modifiers[#Meshsmooth].enabledInRenders = true
				)
				catch ()			
			)
			
		if i != 5 then () -- OFF IN RENDERER
				else
			(
				for i in objects do try
				(
					i.modifiers[#Meshsmooth].enabledInViews = true
					i.modifiers[#Meshsmooth].enabled = true
					i.modifiers[#Meshsmooth].enabledInRenders = false
				)
				catch ()
			)
			
	)
	on shell_drop selected i do
	(
		if i != 1 then () -- MANUAL 
		else()
		
		if i != 2 then () -- ON
		else
			(
				for i in objects do try 
				(
					i.modifiers[#Shell].enabledInViews = true
					i.modifiers[#Shell].enabled = true
				)
				catch ()
			)

		if i != 3 then () -- OFF
		else
			(
				for i in objects do try 
				(
					i.modifiers[#Shell].enabledInViews = true
					i.modifiers[#Shell].enabled = false
				)
				catch ()
			)
			
		if i != 4 then () -- OFF IN VIEWPORT
				else
			(
				for i in objects do try
				(
					i.modifiers[#Shell].enabledInViews = false
					i.modifiers[#Shell].enabled = true
					i.modifiers[#Shell].enabledInRenders = true
				)
				catch ()			
			)
			
		if i != 5 then () -- OFF IN RENDERER
				else
			(
				for i in objects do try
				(
					i.modifiers[#Shell].enabledInViews = true
					i.modifiers[#Shell].enabled = true
					i.modifiers[#Shell].enabledInRenders = false
				)
				catch ()
			)
			
	)
	on hair_and_fur_drop selected i do
	(
		if i != 1 then () -- MANUAL 
		else()
		
		if i != 2 then () -- ON
		else
			(
				for i in objects do try 
				(
					i.modifiers[#Hair_and_fur].enabledInViews = true
					i.modifiers[#Hair_and_fur].enabled = true
				)
				catch ()
			)

		if i != 3 then () -- OFF
		else
			(
				for i in objects do try 
				(
					i.modifiers[#Hair_and_fur].enabledInViews = true
					i.modifiers[#Hair_and_fur].enabled = false
				)
				catch ()
			)
			
		if i != 4 then () -- OFF IN VIEWPORT
				else
			(
				for i in objects do try
				(
					i.modifiers[#Hair_and_fur].enabled = true
					i.modifiers[#Hair_and_fur].enabledInRenders = true
					i.modifiers[#Hair_and_fur].enabledInViews = false
				)
				catch ()			
			)
			
		if i != 5 then () -- OFF IN RENDERER
				else
			(
				for i in objects do try
				(
					i.modifiers[#Hair_and_fur].enabledInViews = true
					i.modifiers[#Hair_and_fur].enabled = true
					i.modifiers[#Hair_and_fur].enabledInRenders = false
				)
				catch ()
			)
			
	)
	on subdivide_drop selected i do
	(
		if i != 1 then () -- MANUAL 
		else()
		
		if i != 2 then () -- ON
		else
			(
				for i in objects do try 
				(
					i.modifiers[#subdivide].enabledInViews = true
					i.modifiers[#subdivide].enabled = true
				)
				catch ()
			)

		if i != 3 then () -- OFF
		else
			(
				for i in objects do try 
				(
					i.modifiers[#subdivide].enabledInViews = true
					i.modifiers[#subdivide].enabled = false
				)
				catch ()
			)
			
		if i != 4 then () -- OFF IN VIEWPORT
				else
			(
				for i in objects do try
				(
					i.modifiers[#subdivide].enabledInViews = false
					i.modifiers[#subdivide].enabled = true
					i.modifiers[#subdivide].enabledInRenders = true
				)
				catch ()			
			)
			
		if i != 5 then () -- OFF IN RENDERER
				else
			(
				for i in objects do try
				(
					i.modifiers[#subdivide].enabledInViews = true
					i.modifiers[#subdivide].enabled = true
					i.modifiers[#subdivide].enabledInRenders = false
				)
				catch ()
			)
			
	)
)

--*****************************************************
					-- <<< Rigging Tools >>> --
--*****************************************************

--"Auto IK Stretch Script" written by Tyson Ibele(tysonibele.com)

rollout riggingTools "Rigging Tools"
(
	groupBox grp1 "Ik Stretch" pos:[3,3] width:156 height:65
	button autoik "Stretchy" pos: [10,21] width:70 height:20 tooltip:"Creates a stretchy IK chain, by applying to an IK Handle."
	checkbox check1 "Allow negative stretch" align:#left
	button noik "Remove" pos: [83,21] width:70 height:20 tooltip:"Cleanly removes scripted controlers for stretchy IK Chain."
	
		on autoik pressed do
	(
		for b in 1 to selection.count do
		(
			max create mode
			if selection != undefined then
			(
				ikchainpoint = selection[b]
				endbone = ikchainpoint.controller.endjoint
				startjoint = ikchainpoint.controller.endjoint
				
				parentbones[1] = endbone
				parentbones.count = 1
				count = 1
				while startjoint != ikchainpoint.controller.startjoint do
				(
					
					parentbones[count+1] = parentbones[count].parent
					count += 1
					startjoint = startjoint.parent			
				)
				
						
				if endbone != undefined and ikchainpoint != undefined then
				(
					in coordsys world distance1 = (distance ikchainpoint.pos parentbones[1].pos)
					
					chainCA = attributes chain
					(
						parameters main rollout:params
						(
							stretchval type:#float ui:sval
							checkval type:#boolean ui:chval
							smoothcheck type:#boolean ui:cval
							smoothmult type:#float ui:mval
							posval type:#point3 animatable:true
						)
						
						rollout params "Extra Stretch Parameters"
						(
							spinner sval "Stretch Value: " type:#float range:[-400,400,0]
							checkbox chval "Allow negative stretch" type:#boolean align:#center
							label label1 "----"
							checkbox cval "Enable Smooth Stretch" 
							spinner mval "Smoothness: " type:#float range:[0,2.5,1]
						)
					)
					try(custattributes.delete ikchainpoint 1)catch()
					custAttributes.add ikchainpoint chainCA
					
					obj1= Point()
					obj1.name = "stretchHelper_" + obj1.name
					obj1.transform = ikchainpoint.transform
					obj1.parent = ikchainpoint
					obj1.scale = [.001,.001,.001]
					selection[b].posval.controller = point3_script()
					selection[b].posval.controller.addNode "helper_point" obj1
					selection[b].posval.controller.script = 
					"(in coordsys world(helper_point.parent.pos))"
					selection[b].smoothcheck = true
					selection[b].smoothmult = 1
					if check1.checked == true then selection[b].checkval = true else selection[b].checkval = false
	
					for k in 1 to (parentbones.count - 1) do
					(
						global f = 2
						parentbones[k].position.controller=Position_XYZ()
						parentbones[k].position.controller=position_list()
						parentbones[k].position.controller.available.controller = position_xyz()
						parentbones[k].position.controller[f].controller.x_position.controller=float_script()
	
						
					)
												
					for m in 1 to (parentbones.count - 1) do
					(
						in coordsys world distance1 = distance1 + (distance parentbones[m] parentbones[m+1]) 			
					
					)
					initScale = abs(parentbones[parentbones.count].scale[1])
			
			
					IKscript = "try(in coordsys world (	d = distance topLevelBone.pos ikChainPoint1)
								
								scale1 = abs(topLevelBone.scale[1])
								distance1 *= scale1/initscale
								st = (d - distance1)
								
								if checkval != true then
								(
									if (st < 0) then st = 0 							
								)
								
								if smoothcheck == true and checkval != true then
								(
															
									value = -(abs(distance1 - d)/distance1) - .5
									value *= 5 
									mult = 2.7 / (smoothmult)
									if mult < 1 then mult = 1
									amount2 = (1/(sqrt(3.14 )))*(mult)^-(((value)^2)/2)
									amount2 *= (distance1/3) * 2
								
								)else amount2 = 0
								
								amount2 = abs(amount2)
								
								amount = ((st  + amount2 + stretchval)/count1)
								
								(orig1 + amount/scale1))catch()"
			
					
					for q in 1 to (parentbones.count - 1) do
					(
					parentbones[q].position.controller[f].controller.x_position.controller.addnode "topLevelBone" ikchainpoint.controller.startJoint			
					parentbones[q].position.controller[f].controller.x_position.controller.addTarget "ikChainPoint1" ikchainpoint.posval.controller
					parentbones[q].position.controller[f].controller.x_position.controller.addconstant "distance1" distance1
					parentbones[q].position.controller[f].controller.x_position.controller.addconstant "orig1" (parentbones[q].position.controller[f].controller.x_position.controller.script as float)
					parentbones[q].position.controller[f].controller.x_position.controller.addconstant "count1" ((parentbones.count - 1) as integer)
					parentbones[q].position.controller[f].controller.x_position.controller.addconstant "initScale" initScale
					parentbones[q].position.controller[f].controller.x_position.controller.addTarget "stretchval" ikchainpoint.baseObject.chain[1]
					parentbones[q].position.controller[f].controller.x_position.controller.addTarget "checkval" ikchainpoint.baseObject.chain[2]
					parentbones[q].position.controller[f].controller.x_position.controller.addTarget "smoothcheck" ikchainpoint.baseObject.chain[3]
					parentbones[q].position.controller[f].controller.x_position.controller.addTarget "smoothmult" ikchainpoint.baseObject.chain[4]
				
					parentbones[q].position.controller[f].controller.x_position.controller.script = IKscript
					max create mode	
					)					
					)
							
			)
		)
	)
		
		on noik pressed do
		(
			for p in 1 to selection.count do
			(
			
				obj = selection[p].controller.endjoint
				try(selection[p].posval.controller = bezier_point3())catch()
				for j in 1 to 100 do
				(
					
						try(orig1 = obj.position.controller[1][1].controller.getconstant "orig1")catch()
						obj.position.controller=bezier_position()
						obj.position.controller=position_xyz()	
						try(in coordsys obj.parent (obj.position.x = orig1))catch()
						orig1 = undefined
						obj = obj.parent	
					
					if obj == selection[p].controller.startjoint then exit
				)
			
			try(delete (selection[p].posval.controller.getNode "helper_point"))catch()
			selection[p].pos = selection[p].pos
			)
		)

	groupBox grp2 "Bone Tools" pos:[3,72] width:156 height:45
		button stretchPoint "StretchPoint" pos:[10,89] width:70 height:20 tooltip:"Creates a stretchy bone, squash enabled, with controlers on each end."
		button pistonMaker "PistonMaker" pos:[83,89] width:70 height:20 tooltip:"Rigs two objects together to act like a piston objects, and creates controlers."
		
	on stretchPoint pressed do
	(
		try
		( 
			controlPoint = point box:on wirecolor:green
			controlPointUpnode = point box:on wirecolor:green                 
			controlPoint.transform = $.transform 
			$.pos.controller = position_list ()       
			$.pos.controller.Available.controller = Position_Constraint () 
			$.pos.controller.Position_Constraint.constraints.appendTarget controlPoint 100     
			select $.parent
			controlPointUpnode.transform = $.transform
			$.parent = controlPointUpnode                                   
			$.rotation.controller = rotation_list ()                  
			$.rotation.controller.Available.controller = LookAt_Constraint ()  
			$.rotation.controller.LookAt_Constraint.constraints.appendTarget controlPoint 100 
			$.rotation.controller.LookAt_Constraint.controller.upnode_world = off
			$.rotation.controller.LookAt_Constraint.controller.pickUpNode = controlPointUpnode
			$.rotation.controller.LookAt_Constraint.lookat_vector_length = 10 
			$.boneFreezeLength=false                                 
			$.boneScaleType=#squash                               
			select controlPoint   
		)catch(messagebox("Select the endbone")) 	
	)
	
	on pistonMaker pressed do
	(
		try
		(
			global switchVariable 
			switchVariable = False
			
			if selection.count != 2 then
			(
				messagebox("You must select Two (2) objects")
			)
			else 
			(
			
			hydPoint01 = Point pos:[0,0,0] Box:off cross:on wirecolor:red 
			hydPoint02 = Point pos:[0,0,0] Box:off cross:on wirecolor:red 
			
				for i in 1 to selection.count do
				(
					if switchVariable != true then
					(
			
						hydPoint01.transform = selection[i].transform
						selection[i].parent = hydPoint01
						selection[i].rotation.controller = rotation_list () 
						selection[i].rotation.controller.Available.controller = LookAt_Constraint ()  a
						selection[i].rotation.controller.LookAt_Constraint.constraints.appendTarget hydPoint02 100 
						selection[i].rotation.controller.LookAt_Constraint.controller.target_axis = 2
						selection[i].rotation.controller.LookAt_Constraint.controller.upnode_axis = 1
						selection[i].rotation.controller.LookAt_Constraint.controller.StoUP_axis = 1
						selection[i].rotation.controller.LookAt_Constraint.controller.viewline_length_abs = off
						selection[i].rotation.controller.LookAt_Constraint.controller.lookat_vector_length = 0

						switchVariable = true
					)
					else
					(
			
						hydPoint02.transform = selection[i].transform
						selection[i].parent = hydPoint02
						selection[i].rotation.controller = rotation_list () 
						selection[i].rotation.controller.Available.controller = LookAt_Constraint ()  a
						selection[i].rotation.controller.LookAt_Constraint.constraints.appendTarget hydPoint01 100
						selection[i].rotation.controller.LookAt_Constraint.controller.target_axis = 2
						selection[i].rotation.controller.LookAt_Constraint.controller.upnode_axis = 1
						selection[i].rotation.controller.LookAt_Constraint.controller.StoUP_axis = 1
						selection[i].rotation.controller.LookAt_Constraint.controller.viewline_length_abs = off
						selection[i].rotation.controller.LookAt_Constraint.controller.lookat_vector_length = 0
					)
				)
			)
		)catch(messagebox("You must select Two (2) objects")) 
	)
	
	groupBox grp3 "Controlers" pos:[3,120] width:156 height:65
		button zero "Zero" pos:[10,138] width:70 height:20 tooltip:"Creates a zeroed out position and euler controlers for your objects."
		button contClear "Clear" pos:[83,138] width:70 height:20 tooltip:"Clears all controlers/constraints on an object and resets them to new."
		checkbox freezeCheck "Freeze Transforms" align:#left 
	
	on zero pressed do
	(
		for i in 1 to selection.count do
		(
			selection[i].pos.controller = position_list ()
			selection[i].pos.controller.Available.controller = Position_XYZ ()
			selection[i].rotation.controller = rotation_list ()
			selection[i].rotation.controller.Available.controller = Euler_XYZ ()

			if freezeCheck.checked == true then macros.run "Animation Tools" "FreezeTransform" else ()
		)
	)
	
	on contClear pressed do
	(
		for i in 1 to selection.count do
		(
			selection[i].pos.controller = Position_XYZ ()
			selection[i].rotation.controller = Euler_XYZ ()
			
			if freezeCheck.checked == true then macros.run "Animation Tools" "FreezeTransform" else ()
		)
	)
	
	groupBox grp6 "Control Objects" pos:[3,191] width:156 height:45
		button ctrlRing "Ctrl Ring" pos:[10,210] width:70 height:20 tooltip:"Creates spline control object with the selected object parented to it."
		button ctrlNode "Gimbal Node" pos:[83,210] width:70 height:20 tooltip:"Creates a parent point helper aligned to local space to the selected object, this is intended to avoid gimbal lock issues."
	
	on ctrlRing pressed do
	(
		try(
			for i in 1 to selection.count do
				(
				cring = circle radius:15 wirecolor:green
				cring.thickness = (cring.radius/20)
				cring.renderable = off
				cring.transform = selection[i].transform
				in coordsys cring (rotate cring (angleaxis 90 [0,1,0]))
				selection[i].parent = cring
				cring.showFrozenInGray = off
				)
			)catch (messagebox "Select Object(s)")
	)
	
	on ctrlNode pressed do
	(
		try
		(
			selectionVar = false
			if selection.count == 1 then(selectionVar = true)else()
			for i in 1 to selection.count do
			(
				nodePoint = point centermarker:off axistripod:off cross:on Box:on 
				nodePoint.wirecolor = color 169 0 0
				nodePoint.transform = selection[i].transform
				selection[i].parent = nodePoint
				if selectionVar == true then (select nodePoint) else()
			)			
		)catch(messagebox("Select Object(s)"))
	)
	
	groupBox grp9 "Cordsys Controls" pos:[3,240] width:156 height:68
	button rigMirror "Mirror Rig" pos:[10,258] width:143 height:20 thickness:2 tooltip:"Groups assembly, flips in x, ungroups, and flips any look at constraints"
	button centerPivot "Center Pivot" pos:[83,282] width:70 height:20 thickness:2  tooltip:"Moves objects pivot to the objects center."
	button centerOrigin "Center Origin" pos:[10,282] width:70 height:20 thickness:2 tooltip:"Moves the selected objects to the origin."
	
	on rigMirror pressed do
	(
		tempGroup = group selection name:"TempGroup"
		tempgroup.pivot = [0,0,0]
		scale tempgroup [-1,1,1]
		ungroup tempGroup
		
		for i in 1 to selection.count do
			(
			try
				(
					if selection[i].rotation.controller.LookAt_Constraint.controller.target_axisFlip == off then (lookatVal = 1)else()
					if selection[i].rotation.controller.LookAt_Constraint.controller.target_axisFlip == on then (lookatVal = 2)else()
					if(lookatVal ==1)then(selection[i].rotation.controller.LookAt_Constraint.controller.target_axisFlip = on)	else()
					if(lookatVal ==2)then(selection[i].rotation.controller.LookAt_Constraint.controller.target_axisFlip = off)	else()
				)
			catch()
			)
	)
	
	on centerPivot pressed do
	(
		mapped fn center_pivot o =
		(
		o.pivot = o.center
		)		
		undo on (
			center_pivot selection
		)
	)
	
	on centerOrigin pressed do
	(
		$.position =  [0,0,0]
	)
)

--*****************************************************
					-- <<< Plugin Tools >>> --
--*****************************************************

rollout pluginTools "DTB Plugins"
(
	groupBox grp6 "launch Script" pos:[3,3] width:156 height:45
	button debrisMaker "DebrisMaker" pos:[10,21] width:70 height:20 tooltip:"Launces the Debris Maker script."
	button AEPosExporterButton "AE Export" pos:[83,21] width:70 height:20 tooltip:"Launces the After Effects 3D position exporter script."

	on debrisMaker pressed do
	(
	GetDir #Scripts
	fileIn "DTB\DebrisMaker.ms"
	)
	on AEPosExporterButton pressed do
	(
	GetDir #Scripts
	fileIn "DTB\AE_Position_Exporter.ms"
	)
)

--*****************************************************
					-- <<< Shading Tools >>> --
--*****************************************************

rollout renderTools "Shading Tools"
(
	groupBox grp8 "Color Pallette" pos:[3,3] width:156 height:57
	colorPicker cp1 "" pos:[6,18] width:35 height:35 color: gray tooltip:"Drag a color onto me."
	colorPicker cp2 "" pos:[43,18] width:35 height:35 color: gray tooltip:"Drag a color onto me."
	colorPicker cp3 "" pos:[80,18] width:35 height:35 color: gray tooltip:"Drag a color onto me."
	colorPicker cp4 "" pos:[117,18] width:35 height:35 color: gray tooltip:"Drag a color onto me."
)

--*****************************************************
					-- <<< Information >>> --
--*****************************************************

	rollout info "Information"
	(
		hyperLink aaronDabelow "© 2010  Aaron Dabelow" address:"http://aarondabelow.com/" pos:[10,9]  tooltip:"www.aarondabelow.com"
		button informationButton "?" pos: [136,6] width: 20 height:20  tooltip:"Information"
		on informationButton pressed do
		(
		try(closerolloutfloater InformationDialog)catch()
		rollout InformationDialog "DTB Info"
			(
			bitmap dtbHeadder fileName:"Scripts\DTB\dtb_headder.gif" width: 164 height:47 align:#center
			hyperLink DTBLink "Dabelow Tool Box  v1.0  Help" address:"http://www.aarondabelow.com/pages/dabelow_tool_box.html" align:#center
			label labSpace1 ""
			hyperLink aaronDabelow "Aaron Dabelow" address:"http://aarondabelow.com/" align:#center
			label lab6 "theonlyaaron@gmail.com"
			label labSpace2 ""
			)
		createDialog InformationDialog 175 150
	)
)

--*****************************************************
				-- <<< Floater Functions >>> --
--*****************************************************

global atools
global lowerleg
global endbone
global ikchainpoint
global IKscript
global distance1
global numbones1
global parentbones = #()

atools=newrolloutfloater "DTB v1.0" 175 815 0 82

addrollout modelingTools atools
addrollout meshGlobals atools
addrollout riggingTools atools
addrollout pluginTools atools
addrollout renderTools atools
addrollout info atools

)catch()