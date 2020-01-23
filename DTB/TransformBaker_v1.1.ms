--****--*************************************************
-- TransfomBaker.ms
--
-- 3.29.11
--Aaron Dabelow, theonlyaaron@gmail.com
-- www.aarondabelow.com
-- Written for MAX v.9.0 and up
--*****************************************************
-- PURPOSE:
--		quickly duplicate objects transformations onto a new
--		object, regardless of constraints, animation, or other
--		transformations
--*****************************************************
-- HISTORY:
--    - v1.0 (3.2.10):
--        (i) 1st version.
--    - v1.0 (3.29.11):
--        (i) added group selection mode
--        (i) added replace controler mode
--        (i) cleaned up UI
--*****************************************************

--------------------------------------------------------------
-------------------- VARIABLE SETUP--------------------
--------------------------------------------------------------

try(closeRolloutFloater transformsBaker)catch()
(
global framesStart
global framesEnd
global theAnimatedObject
global currentFrame
global totalFrames
global controlTypeCheck
global objectTypeCheck
	
theanimatedobject = "undefined"
framesStart = 0
framesEnd = 100
clipboardString = "defined"
currentFrame = 0
totalFrames = 100
controlTypeCheck = "object"
objectTypeCheck = "selection"
)
--------------------------------------------------------------
--------------SELECT OBJECT ROLLOUT----------------
--------------------------------------------------------------

Rollout TransformsBakerRollout2 "Bake To Object"
(
	groupBox ObjectsGroup "Object" width:151 height:65 pos: [5,5]
	pickbutton loadUserDefined "Select Object" width:92  pos: [13,22] enabled:false
	button clearUserDefined "Clear" width:43 pos: [105,22] enabled:false
	checkbox selectionCheck "Run on selected Objects" tristate:1 pos: [13,48]

	groupBox framesGroup "Frames" width:151 height:68 pos: [5,75]
	spinner framesStartSpinner "" range:[0,99999,0] width:58 type:#integer pos: [13,93]
	spinner framesEndSpinner "To " range:[0,99999,100] width:70 type:#integer pos: [78,93]
	button timeSnap "Snap to Timeline" width: 135 height:20 pos: [13,115]
	
	groupBox TypeGroup "Type of operation" width:151 height:70 pos: [5,148]
	checkButton ControlObjectButton "Bake to Control Object" width:135 height:20 pos: [13,165] checked:true
	checkButton ReplaceControlerButton "Replace Objects Controler" width:135 height:20 pos: [13,190] checked:false
	
	groupBox Processing "Bake" width:151 height:90 pos: [5,222]
	button BakeButton " Bake Transforms " width: 135 height:40 pos: [13,238]
	progressbar TotalProgress   width: 135 height:10 pos: [13,285] color:Blue
	progressbar objProgress   width: 135 height:10 pos: [13,295] color: green
	
	hyperLink aaronDabelow "© 2011  Aaron Dabelow" address:"http://aarondabelow.com/" pos: [7,320]
	button informationButton "?"  width: 20 height:20 pos: [136,316]
	
	------------------BAKING PROCESS-----------------------
	
on BakeButton pressed do
	(
	
	if theanimatedobject != "undefined" or objectTypeCheck == "selection" then
		(
		try
			(
			disableSceneRedraw()
				
			if controlTypeCheck == "object" then ()
					else
						(
						globalpoint  = point ()
						)
				
			oldAnimationRange = animationRange
			animationRange = interval framesStart FramesEnd
			oldSliderTime = sliderTime
				
			StoredSelection = selection
				
			for j in 1 to selection.count do
				(
				
				select = storedSelection
				theanimatedobject = selection[j]
				
				if theanimatedobject != undefined then
					(
						
					theNewPoint = Point pos:[0,0,0] size:70 Box:on cross:on axistripod:off centermarker:off wirecolor:red
						
					sliderTime = framesStart
						
					totalFrames =(framesEnd-framesStart)
					currentFrame = 0
						
					max tool animmode
					set animate on
						
						
					 for i in framesStart to framesEnd do
						(
						theNewPoint.transform = theAnimatedObject.transform
						
						currentFrameText = "	"+((currentTime as integer)/TicksPerFrame) as string
						print currentFrameText
						
						sliderTime =(sliderTime+1)
						
						objProgress.value = 100.*currentFrame/totalFrames
						currentFrame = (currentFrame+1)
						)
						
					objProgress.value = 0
						
					max tool animmode
					set animate off
					
					if controlTypeCheck == "object" then ()
					else
						(
						theanimatedobject.parent = globalpoint
							
						posCtrl = theNewPoint.pos.controller
						rotCtrl = theNewPoint.rotation.controller
						scaleCtrl = theNewPoint.scale.controller
						theAnimatedObject.pos.controller = posCtrl
						theAnimatedObject.rotation.controller = rotCtrl
						theAnimatedObject.scale.controller = scaleCtrl
							
						delete theNewPoint
						)
					)else()
				
				TotalProgress.value = 100.*j/selection.count
					
				)
			try (delete GlobalPoint) catch()
			
			TotalProgress.value = 0
				
			animationRange = oldAnimationRange 
			SliderTime = oldSliderTime
			enableSceneRedraw()
			
			)catch(Messagebox "Script Error")
		)else(messagebox"Load object")
	)	
	
	-----------------------UI STUFF---------------------------
on informationButton pressed do
	(rollout InformationDialog "AE Position Exporter Info"
		(
		hyperLink DTBLink "Transform Baker v1.1  Help" address:"http://www.aarondabelow.com/pages/AE_Pos_Export.html" align:#center
		label lab4 ""
		label lab5 "Select an object and click on" align:#left
		label lab6 "bake transforms to create a new" align:#left
		label lab7 "point object with the collapsed" align:#left
		label lab8 "transforms of the original object" align:#left
		label lab9 ""
		hyperLink aaronDabelow "Aaron Dabelow" address:"http://aarondabelow.com/" align:#center
		label lab21 "theonlyaaron@gmail.com"
		)
	createDialog InformationDialog 225 200
	)
	
on controlObjectButton changed state do
	(
		if state == on then 
		(
		ReplaceControlerButton.checked = off
		controlTypeCheck = "object"
		print ("Operantion Mode: " + controlTypeCheck)
		)
		else
		(
		ReplaceControlerButton.checked = on
		controlTypeCheck = "controler"
		print ("Operation Mode: " + controlTypeCheck)
		)
	)
	
on ReplaceControlerButton changed state do
	(
		if state == on then 
		(
		controlObjectButton.checked = off
		controlTypeCheck = "controler"
		print ("Controler Mode: " + controlTypeCheck)
		)
		else
		(
		controlObjectButton.checked = on
		controlTypeCheck = "object"
		print ("Controler Mode: " + controlTypeCheck)
		)
	)
	
on selectionCheck changed thing do
	(
		If selectionCheck.checked != true then
		(
			loadUserDefined.enabled = true
			clearUserDefined.enabled = true
			objectTypeCheck = "single"
			print ("Object Mode: " + objectTypeCheck)
		)
		else
		(
			loadUserDefined.enabled = false
			clearUserDefined.enabled = false
			objectTypeCheck = "selection"
			print ("Object Mode: " + objectTypeCheck)
		)
	)
		
on loadUserDefined picked loadUserDefinedVar do
	(
		if loadUserDefinedVar != undefined then
		(
			theAnimatedObject = loadUserDefinedVar
			loadUserDefined.text = theAnimatedObject.name
			select theanimatedobject
		)
		else(messagebox "Select valid node")
	)
	
on clearUserDefined pressed do
		(
		loadUserDefined.text = "Select Object"
		theanimatedobject = "undefined"
		)
		
on framesStartSpinner changed framesStartVal do
		(
		framesStart = framesStartVal
		print ("Start Frame: " + framesStart as string)
			
		if (framesStart >= framesEnd) then
			(
			framesEndUpdate = (framesStart+1)
			framesEnd = framesEndUpdate
			print framesEndUpdate
			framesEndSpinner.range = [0,99999,framesEndUpdate]
			)
		else ()
			
		)
	
on framesEndSpinner changed framesEndVal do
		(
		framesEnd = framesEndVal
		print ("End Frame: " + framesEnd as string)
			
		if (framesStart >= framesEnd) then
			(
			framesStartUpdate = (framesEnd-1)
			framesStart = framesStartUpdate
			print framesStartUpdate
			framesStartSpinner.range = [0,99999,framesStartUpdate]
			)
		else ()
			
		)	
		
on timeSnap pressed do
		(
		framesStartSpinner.range = [0,99999,animationRange.start]
		framesEndSpinner.range = [0,99999,animationRange.end]
		framesStart = animationRange.start
		framesEnd = animationRange.end
		framesStartVal = framesStart
		framesEndVal = framesEnd
		print ("Start Frame: " + framesStart as string)
		print ("End Frame: " + framesEnd as string)
		)	
)
--------------------------------------------------------------
--------------FLOATER CONSTRUCTION----------------
--------------------------------------------------------------

transformsBaker=newrolloutfloater "Transform Baker" 175 372 198 82
--addrollout transformsBakerRollout transformsBaker
addrollout transformsBakerRollout2 transformsBaker