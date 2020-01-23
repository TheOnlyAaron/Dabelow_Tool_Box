--*****************************************************
-- TransfomBaker.ms
--
-- 3.2.10
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
	
theanimatedobject = "undefined"
framesStart = 0
framesEnd = 100
clipboardString = "defined"
currentFrame = 0
totalFrames = 100
)
--------------------------------------------------------------
--------------SELECT OBJECT ROLLOUT----------------
--------------------------------------------------------------

rollout transformsBakerRollout "Select Object"
(
	groupBox ObjectsGroup "Object" width:151 height:70 pos: [5,5]
	pickbutton loadUserDefined "Select Object" width:85  pos: [13,22]
	button clearUserDefined "Clear" width:43 pos: [105,22]
	multiListBox userDefinedFileList height:1

	groupBox framesGroup "Frames" width:151 height:70 pos: [5,80]
	spinner framesStartSpinner "" range:[0,99999,0] width:58 type:#integer pos: [13,98]
	spinner framesEndSpinner "To " range:[0,99999,100] width:70 type:#integer pos: [78,98]
	button timeSnap "Snap to Timeline" width: 135 height:20 pos: [13,122]
	
	groupBox Processing "Bake" width:151 height:80 pos: [5,155]
	button processPositions " Bake Transforms " width: 135 height:40 pos: [13,172]
	progressbar objProgress   width: 135 height:10 pos: [13,218]
		
	hyperLink aaronDabelow "© 2010  Aaron Dabelow" address:"http://aarondabelow.com/" pos: [7,241]
	button informationButton "?"  width: 20 height:20 pos: [136,239]
	
--------------------------------------------------------------
----------------------SCRIPT BODY------------------------
--------------------------------------------------------------

	on loadUserDefined pressed do
		(
		if isValidNode ladUserDefinedVar do
			(
				userDefinedFileList.items = (userDefinedFileList.items + #("B"))
			)
		)
		
	on loadUserDefined picked loadUserDefinedVar do
	(
		if loadUserDefinedVar != undefined then
		(
			theAnimatedObject = loadUserDefinedVar
			userDefinedFileList.items = #(theAnimatedObject.name as string)
			select theanimatedobject
		)
		else(messagebox "Select valid node")
	)

	on clearUserDefined pressed do
		(
		userDefinedFileList.items = #()
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

----------------------------BAKING PROCESS---------------------------------
		
	on processPositions pressed do
		(
		if theanimatedobject != "undefined" then
			(
			try
				(
				disableSceneRedraw()
					
				oldAnimationRange = animationRange
				animationRange = interval framesStart FramesEnd
				
				oldSliderTime = sliderTime
				
				if theanimatedobject != undefined then
					(
						
					theNewPoint = Point pos:[0,0,0] isSelected:on size:70 Box:on cross:on axistripod:off centermarker:off wirecolor:red
						
					deselect
					select theanimatedobject
						
					sliderTime = framesStart
						
					totalFrames =(framesEnd-framesStart)
					currentFrame = 0
						
					max tool animmode
					set animate on
						
						
					 for i in framesStart to framesEnd do
						(
						select theAnimatedObject
						theNewPoint.transform = $.transform
						
						currentFrameText = "	"+((currentTime as integer)/TicksPerFrame) as string
						print currentFrameText
						
						sliderTime =(sliderTime+1)
						
						objProgress.value = 100.*currentFrame/totalFrames
						currentFrame = (currentFrame+1)
						)
						
					objProgress.value = 0
						
					max tool animmode
					set animate off
						
					)else()
					
				animationRange = oldAnimationRange 
				SliderTime = oldSliderTime
				enableSceneRedraw()
				
				)catch(Messagebox "Script Error")
			)else(messagebox"Load object")
		)	
	
	on informationButton pressed do
		(rollout InformationDialog "AE Position Exporter Info"
			(
			hyperLink DTBLink "Transform Baker v1.0  Help" address:"http://www.aarondabelow.com/pages/AE_Pos_Export.html" align:#center
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
)

--------------------------------------------------------------
--------------FLOATER CONSTRUCTION----------------
--------------------------------------------------------------

transformsBaker=newrolloutfloater "Transform Baker" 175 295 198 82
addrollout transformsBakerRollout transformsBaker