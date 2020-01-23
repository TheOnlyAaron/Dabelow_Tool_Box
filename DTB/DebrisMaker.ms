--*****************************************************
-- Debris_Maker_v1.0.ms
--
-- 1.2.10
--Aaron Dabelow, theonlyaaron@gmail.com
-- www.aarondabelow.com
-- Written for MAX v.9.0 and up
--*****************************************************
-- PURPOSE:
--      To create and prepare various types of simple
--       geometry object sets to be used as object sets in 
--	    particle simulations or set dressing.
--*****************************************************
-- HISTORY:
--    - v1.0 (1.2.10):
--        (i) 1st version.
--*****************************************************

--------------------------------------------------------------
-------------------- VARIABLE SETUP--------------------
--------------------------------------------------------------

(
try(closeRolloutFloater debrisMaker)catch()

global debrisArray	
Global debrisDetail
Global CreateUVWs
Global createGroups
Global generateParticles
Global collapseStackVariable
Global debrisIrregularity
Global amountOfDebris
Global typeVal
Global displayVal
Global particlesOff
Global hideViewport
Global flowType
global addGravity
	
debrisArray = #()
amountOfDebris = 3
debrisIrregularity = 1
debrisDetail = 1
typeVal = "rubble"
displayVal = "RandWires"
CreateUVWs = false
createGroups = false
collapseStackVariable = false
particlesOff = false
hideViewport = false
flowType = "Simple"
generateParticles = false
addGravity = false
	
)

--------------------------------------------------------------
--------------DEBRIS MENU CREATION ----------------
--------------------------------------------------------------

rollout DebrisVariables "Debris Variables"
(
	dropdownlist type_drop
	items:#("-- Select Type --","   Rubble","   Splinters","   Plates","   Gumdrop") height:20
	
	on type_drop selected i do
	(
		if i != 1 then ()  -- SELECT TYPE
			else (typeVal = "none")
		
		if i != 2 then () -- RUBBLE
			else (typeVal = "rubble")
		
		if i != 3 then () -- SPLINTERS
			else (typeVal = "splinters")
		
		if i != 4 then () -- PLATES
			else (typeVal = "plates")
		
		if i != 5 then () -- GUMDROPS
			else (typeVal = "gumdrops")
	)
			
	spinner numberSpinner "Amount of Debris    " range:[1,20,3] type:#integer fieldWidth:32 
	on numberSpinner changed amountOfDebrisVal do
		(amountOfDebris = amountOfDebrisVal	)
		
	spinner irregularitySpinner "Debris Irregularity    " range:[1,3,1] type:#integer fieldWidth:32 
	on irregularitySpinner changed debrisIrregularityVal do 
		(debrisIrregularity = debrisIrregularityVal)
		
	spinner detailSpinner "Debris Detail Level " range:[1,3,1] type:#integer fieldWidth:32 
	on detailSpinner changed debrisDetailVal do 
		(debrisDetail = debrisDetailVal)
		
	checkbox CreateUVWsBox "Create UVs"
	on CreateUVWsBox changed CreateUVWsVal do 
		(CreateUVWs = CreateUVWsVal)
				
	checkbox collapseStackBox "Preserve Stack"
	on collapseStackBox changed collapseStackVal do
		(collapseStackVariable = collapseStackVal)
		
	checkbox createGroupsBox "Create Groups"
	on createGroupsBox changed createGroupsVal do
		(createGroups = createGroupsVal)	
	
	dropdownlist display_drop
	items:#("-- Select Display --","Greyed and Black Wire","Random Wires") height:20
	
	on display_drop selected i do
	(
		if i != 1 then () -- SELECT TYPE
			else (displayVal = "RandWires")
		
		if i != 2 then () -- GREYED
			else (displayVal = "Greyed")	
		
		if i != 3 then () -- RAND WIRES
			else (displayVal = "RandWires")
	)
	
	groupBox particleFlowGroup "Particle Flow" pos:[6,184] width:148 height:125
	
	checkbox generateParticlesBox "Generate Particle Flow" pos:[13,202]
	on generateParticlesBox changed generateParticlesBoxVal do
		(
		generateParticles = generateParticlesBoxVal
		if generateParticlesBox.state == true then (createGroupsBox.tristate = 2)
		else (createGroupsBox.tristate = 0)
		)	
		
	groupBox particleOptionsGroup "pFlow Options" width:134 height:81 

	checkbox addGravityBox " Add Gravity" pos:[27,240]
	on addGravityBox changed addGravityBoxVal do
		(addGravity = addGravityBoxVal)	
		
	checkbox hideViewportBox " Display ticks" pos:[27,260]
	on hideViewportBox changed hideViewportBoxVal do
		(hideViewport = hideViewportBoxVal)	
		
	checkbox particlesOffBox " Particles Off" pos:[27,280]
	on particlesOffBox changed particlesOffBoxVal do
		(particlesOff = particlesOffBoxVal)	
	
)	
--------------------------------------------------------------
------------------- DEBRIS CREATION -------------------
--------------------------------------------------------------

rollout DebrisCreate "Debris Creation"
(
	button createRubble "Generate Debris" width: 150 height:40
	progressbar debrisProgress  pos: [7,52] width: 149 height:10
	hyperLink aaronDabelow "© 2010  Aaron Dabelow" address:"http://aarondabelow.com/" pos: [7,70]
	button informationButton "?" pos: [136,67] width: 20 height:20

	on informationButton pressed do
		(rollout InformationDialog "Debris Maker Info"
			(
			bitmap dtbHeadder fileName:"Scripts\DTB\DM_headder.gif" width: 164 height:47 align:#center
			hyperLink DTBLink "Debris Maker  v1.0  Help" address:"http://www.aarondabelow.com/pages/Debris_Maker.html" align:#center
			label labSpace1 ""
			hyperLink aaronDabelow "Aaron Dabelow" address:"http://aarondabelow.com/" align:#center
			label lab6 "theonlyaaron@gmail.com"
			label labSpace2 ""
			)
		createDialog InformationDialog 175 150
		)
		
	on createRubble pressed do 
	(
		print (amountOfDebris as string + " pieces of " + typeval as string + " with an irregularity of " + debrisIrregularity as string)
		print ("That Display? " + displayVal as string + ". With UVS? " + CreateUVWs as string + ". With Groups? " + createGroups as string + ". Collapsed Stack? " + collapseStackVariable as string )

		if typeval == "none" then 
			(
			Messagebox"Please select a type of debris to create"
			)
		else ()
			
--------------------------------------------------------------
------------------ RUBBLE CREATION-------------------
--------------------------------------------------------------
			
		if typeval == "rubble" then 
			(
			--disableSceneRedraw()
			max modify mode
				
			debrisArray = #()
			debrisItteration = 01
 			debrisIrregularityMath = (debrisIrregularity*3)
				
			if debrisDetail ==1 then (debrisdetailMath = 20) else ()
			if debrisDetail ==2 then (debrisdetailMath = 13) else ()
			if debrisDetail ==3 then (debrisdetailMath = 5) else ()
				
			for i in 1 to amountOfDebris do
				(
				print  DebrisItteration
					
				currentDebris = GeoSphere name:("debris_rubble_" + debrisItteration as string) radius: 8 isSelected:on
				modPanel.addModToSelection (Noisemodifier ()) ui:off
				$.modifiers[#Noise].fractal = on
				$.modifiers[#Noise].strength = [debrisIrregularityMath,debrisIrregularityMath,debrisIrregularityMath]
				$.modifiers[#Noise].scale = 5
				$.modifiers[#Noise].seed = (random 1000 9999)
				modPanel.addModToSelection (optimize ()) ui:off
				$.modifiers[#Optimize].facethreshold1 = 25.5
				modPanel.addModToSelection (TurboSmooth ()) ui:off
				modPanel.addModToSelection (optimize ()) ui:off
				$.modifiers[#Optimize].facethreshold1 = debrisdetailMath
					
				if CreateUVWs == true then
					(
					modPanel.addModToSelection (Uvwmap ()) ui:off
					$.modifiers[#UVW_Mapping].maptype = 4
					)
				else ()

				move $ [((debrisItteration*20)-20),0,0]
				
				join debrisArray #($)
					
				DebrisItteration = (DebrisItteration + 01)
				clearSelection()
				
				debrisProgress.value = 100.*debrisItteration/amountOfDebris
				)
			debrisProgress.value = 0
				
			print debrisArray
			select (debrisArray)
				
			--enableSceneRedraw() 
			)
		else ()
			
--------------------------------------------------------------
------------------ SPLINTER CREATION------------------
--------------------------------------------------------------
			
		if typeval == "splinters" then
			(
			--disableSceneRedraw()
			max modify mode
				
			debrisArray = #()
			debrisItteration = 01
 			debrisIrregularityMath = (debrisIrregularity*2.5)
				
			if debrisDetail ==1 then (debrisdetailMath = 20) else ()
			if debrisDetail ==2 then (debrisdetailMath = 13) else ()
			if debrisDetail ==3 then (debrisdetailMath = 5) else ()
				
			for i in 1 to amountOfDebris do
				(
				randomSplinter = (random 1 3)
				print randomsplinter

				currentDebris = Cylinder name:("debris_splinter_" + debrisItteration as string) smooth:on heightsegs:5 capsegs:1 sides:8 height:30 radius:1.25 mapcoords:on isSelected:on
				macros.run "Modifier Stack" "Convert_to_Poly"

				If randomSplinter == 1 then
					(
					select (currentDebris)
					modPanel.addModToSelection (Taper ()) ui:off
					$.modifiers[#Taper].amount = -0.9
					macros.run "Modifier Stack" "Convert_to_Poly"
					subobjectLevel = 1
					$.EditablePoly.SetSelection #Vertex #{1..8}
					macros.run "Editable Polygon Object" "EPoly_Collapse"
					$.EditablePoly.SetSelection #Vertex #{}
					subobjectLevel = 0
					)
				else ()
		
				If randomSplinter == 2 then
					(
					select (currentDebris)
					macros.run "Modifier Stack" "Convert_to_Poly"
					modPanel.addModToSelection (Taper ()) ui:on
					$.modifiers[#Taper].center += [0,0,15]
					$.modifiers[#Taper].symmetry = on
					$.modifiers[#Taper].amount = -1.71
					)
					else ()

				If randomSplinter == 3 then
					(
					select (currentDebris)
					modPanel.addModToSelection (Taper ()) ui:on
					$.modifiers[#Taper].center += [0,0,30]
					$.modifiers[#Taper].amount = 0.9
					macros.run "Modifier Stack" "Convert_to_Poly"
					subobjectLevel = 1
					$.EditablePoly.SetSelection #Vertex #{41..48}
					macros.run "Editable Polygon Object" "EPoly_Collapse"
					$.EditablePoly.SetSelection #Vertex #{}
					subobjectLevel = 0
					)
					else ()

				modPanel.addModToSelection (Noisemodifier ()) ui:on
				$.modifiers[#Noise].fractal = on
				$.modifiers[#Noise].scale = 20
				$.modifiers[#Noise].strength = [debrisIrregularityMath,debrisIrregularityMath,debrisIrregularityMath]
				$.modifiers[#Noise].seed = (random 1000 9999)
				modPanel.addModToSelection (TurboSmooth ()) ui:on
				modPanel.addModToSelection (optimize ()) ui:on
				$.modifiers[#Optimize].facethreshold1 = debrisdetailMath
				modPanel.addModToSelection (Noisemodifier ()) ui:on
				$.modifiers[#Noise].strength = [1.5,0,0]
				$.modifiers[#Noise].fractal = off
				$.modifiers[#Noise].seed = (random 1000 9999)
				$.modifiers[#Noise].scale = 2.5
					
				if CreateUVWs == true then
					(
					modPanel.addModToSelection (Uvwmap ()) ui:on
					$.modifiers[#UVW_Mapping].maptype = 4
					)
				else ()
				
				move $ [((debrisItteration*10)-10),0,0]
				
				join debrisArray #($)
					
				DebrisItteration = (DebrisItteration + 01)
				clearSelection()
				
				debrisProgress.value = 100.*debrisItteration/amountOfDebris
				)
			debrisProgress.value = 0
			
			print debrisArray
			select (debrisArray)
				
			--enableSceneRedraw()
			)
		else ()
			
--------------------------------------------------------------
-------------------- PLATE CREATION--------------------
--------------------------------------------------------------
		
		if typeval == "plates" then
			(
			--disableSceneRedraw()
			max modify mode
				
			debrisArray = #()
			debrisItteration = 01
							
			debrisEdgesRand = (random 3 7)
			debrisEdgesSegments = (debrisDetail - 1)
			debrisNoiseIrregularity1 = ((random 5 10) * debrisIrregularity)
			debrisNoiseIrregularity2 = ((random 5 10) * debrisIrregularity)
			print (" debrisIrregularityRand " + debrisEdgesRand as string)
			print (" debrisEdgesSegments " + debrisEdgesSegments as string)
			print (" debrisNoiseIrregularity1 - " + debrisNoiseIrregularity1 as string)
			print (" debrisNoiseIrregularity2 - " + debrisNoiseIrregularity2 as string)
				
				for i in 1 to amountOfDebris do
				(
				currentDebris = Ngon name:("debris_plate_" + debrisItteration as string) radius:(random 3 7) cornerRadius:0 nsides:debrisEdgesRand circular:off scribe:0 isSelected:on
				
				modPanel.addModToSelection (Noisemodifier ()) ui:on
				$.modifiers[#Noise].scale = 10
				$.modifiers[#Noise].strength = [debrisNoiseIrregularity1,debrisNoiseIrregularity2,0]
				$.modifiers[#Noise].seed = (random 0000 9999)
					
				subobjectLevel = 2
				modPanel.setCurrentObject $.modifiers[#Noise]
				$.modifiers[#Noise].center += [debrisNoiseIrregularity1,0,0]

				$.steps = debrisEdgesSegments

				modPanel.addModToSelection (Extrude ()) ui:on	
				$.modifiers[#Extrude].amount = 2

				if debrisDetail == 3 then
					(
					modPanel.addModToSelection (subdivide ()) ui:on
					$.modifiers[#Subdivide].size = 5
					modPanel.addModToSelection (Noisemodifier ()) ui:on
					$.modifiers[#Noise].strength = [5,5,2]
					$.modifiers[#Noise].scale = 5
					$.modifiers[#Noise].seed = (random 0000 9999)
					)
					else ()
				
				if CreateUVWs == true then
					(
					modPanel.addModToSelection (Uvwmap ()) ui:on
					$.modifiers[#UVW_Mapping].maptype = 4
					)
				else ()
				
				modPanel.addModToSelection (Cap_Holes ()) ui:on	
				move $ [((debrisItteration*22)-22),0,0]
				join debrisArray #($)
				DebrisItteration = (DebrisItteration + 01)
				clearSelection()
				
				debrisProgress.value = 100.*debrisItteration/amountOfDebris
				)
			debrisProgress.value = 0
				
			print debrisArray
			select (debrisArray)
			
			--enableSceneRedraw() 
			)
		else ()
			
--------------------------------------------------------------
------------------ GUMDROP CREATION------------------
--------------------------------------------------------------
		
		if typeval == "gumdrops" then 
			(
			--disableSceneRedraw()
			max modify mode
							
			debrisArray = #()
			debrisItteration = 01
 			debrisIrregularityMath = (debrisIrregularity*3)
				
			if debrisDetail ==1 then (debrisdetailMath = 20) else ()
			if debrisDetail ==2 then (debrisdetailMath = 13) else ()
			if debrisDetail ==3 then (debrisdetailMath = 5) else ()
				
			for i in 1 to amountOfDebris do
				(
				print  DebrisItteration
					
				currentDebris = GeoSphere name:("debris_gumdrop_" + debrisItteration as string) radius: 8 isSelected:on
				modPanel.addModToSelection (Noisemodifier ()) ui:on
				$.modifiers[#Noise].fractal = on
				$.modifiers[#Noise].strength = [debrisIrregularityMath,debrisIrregularityMath,debrisIrregularityMath]
				$.modifiers[#Noise].scale = 5
				$.modifiers[#Noise].seed = (random 1000 9999)
				modPanel.addModToSelection (optimize ()) ui:on
				$.modifiers[#Optimize].facethreshold1 = 25.5
				modPanel.addModToSelection (TurboSmooth ()) ui:on
				modPanel.addModToSelection (optimize ()) ui:on
				$.modifiers[#Optimize].facethreshold1 = debrisdetailMath
					
				modPanel.addModToSelection (SliceModifier ()) ui:on
				$.modifiers[#Slice].Slice_Type = 2
				modPanel.addModToSelection (Cap_Holes ()) ui:on
					
				if CreateUVWs == true then
					(
					modPanel.addModToSelection (Uvwmap ()) ui:on
					$.modifiers[#UVW_Mapping].maptype = 4
					)
				else ()

				move $ [((debrisItteration*20)-20),0,5]
				
				join debrisArray #($)
					
				DebrisItteration = (DebrisItteration + 01)
				clearSelection()
				
				debrisProgress.value = 100.*debrisItteration/amountOfDebris
				)
			debrisProgress.value = 0
				
			print debrisArray
			select (debrisArray)
			
			--enableSceneRedraw() 
			)
		else ()
			
--------------------------------------------------------------
-------------------- VARIABLE CHECKS--------------------
--------------------------------------------------------------
			
		if collapseStackVariable != true then 
			(
			macros.run "Modifier Stack" "Convert_to_Poly"
			)
		else ()
			
		if displayVal == "RandWires" then 
			(
			
			try(
				meditMaterials[1] = copy meditMaterials[2]
				meditMaterials[1] = Standardmaterial ()
				meditMaterials[1].name = "Default Grey"
				$.material = meditMaterials[1]
				$.showFrozenInGray = off
				)
			Catch(messagebox "ERROR Please re-execute script")
			
			)
		else
			(
			meditMaterials[1] = copy meditMaterials[2]
			meditMaterials[1] = Standardmaterial ()
			meditMaterials[1].name = "Default Grey"
			$.material = meditMaterials[1]
			$.wirecolor = color 0 0 0
			$.showFrozenInGray = off
			)
			
		if createGroups == true or generateParticles == true then
			(
			debrisGroup = group selection name:(typeval + " group of " + amountOfDebris as string)
			select debrisGroup
			)
		else ()
			
		if generateParticles == true then
			(
			timeVal = slidertime
			
			newPFSource = PF_Source X_Coord:20 Y_Coord:0 isSelected:on Logo_Size:20 Emitter_Length:35 Emitter_Width:35 Emitter_Height:0 pos:[-35,0,0]
			rotate $ (angleaxis -180 [0,1,0])
				
			particleFlow.BeginEdit()
			op1 = Birth()
			op2 = Position_Icon location: 0 
			op3 = Speed speed: 350 variation: 50 divergence: 25
			op4 = Rotation()
			op5 = Shape_Instance Shape_Object: debrisGroup Group_Members: on variation: 50 Scale_Value: 50
			op6 = RenderParticles()
			op7 = Force()
			op8 = DisplayParticles type: 6 color:(random (color 0 0 0) (color 255 255 255))
			op9 = DeleteParticles type:2 LifeSpan: 2500 variation: 0
			newPFEvent = Event()
			newPFEvent.SetPViewLocation ($.X_Coord) ($.Y_Coord+100)
			particleFlow.EndEdit()
			newPFEvent.AppendAction op1
			newPFEvent.AppendAction op2
			newPFEvent.AppendAction op3
			newPFEvent.AppendAction op4
			newPFEvent.AppendAction op5
			newPFSource.AppendAction op6
			newPFEvent.AppendAction op7
			newPFEvent.AppendAction op8
			newPFEvent.AppendAction op9
			newPFSource.AppendInitialActionList newPFEvent
			newPFSource.Enable_Particles = on

			if addGravity == true then
				(
				newParticleGravity = gravity pos:[-70,0,0] isSelected:on iconSize:8 transform:(matrix3 [1,0,0] [0,-1,0] [0,0,-1] [0,0,0])
				op7.force_Space_Warps = #(newParticleGravity)
				)
			else ()			
				
			if hideViewport == true then
				(
				op8 = DisplayParticles type: 2
				)
			else ()					
			
			if particlesOff == true then
				(
				newPFSource.Enable_Particles = off
				)
			else ()
			
			holdMaxFile()
			fetchMaxFile quiet:true
			slidertime = timeval
			redrawviews ()
			)	

	)
)

debrisMaker=newrolloutfloater "Debris Maker" 175 462 198 82
addrollout DebrisVariables debrisMaker
addrollout DebrisCreate debrisMaker

