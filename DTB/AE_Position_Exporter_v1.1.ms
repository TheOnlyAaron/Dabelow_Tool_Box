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

try(closeRolloutFloater AEPositionExporter)catch()
(
global framesStart
global framesEnd
global clipboardString
global headderText
global footerText
global clipbpardString
global theAnimatedObject
global currentFrame
global totalFrames
	
theanimatedobject = "undefined"
framesStart = 0
framesEnd = 100
clipboardString = "defined"
xPosition = 1.000
yPosition = 2.000
zPosition = 3.000
currentFrame = 0
totalFrames = 100
)

--------------------------------------------------------------
----------------------SRING SETUP------------------------
--------------------------------------------------------------

headderText = "Adobe After Effects 8.0 Keyframe Data

Transform	Position
	Frame	X pixels	Y pixels	Z pixels"
returnText ="
"
footerText = "
End of Keyframe Data"
clipbpardString = "defined"

--------------------------------------------------------------
----------------STATIC POS ROLLOUT------------------
--------------------------------------------------------------

rollout StaticPositionExporter "Static Position"
(
	groupBox GrabGroup "Grab Static Position" width:151 height:68 pos: [5,5]
	button copyToClipboardStatic " Copy To Clipboard " width: 135 height:20 pos: [13,22] tooltip: "Copy selected objects position data to your clipboard to be pasted into After Effects."
	button saveTextStatic " Save Position as .txt " width: 135 height:20 pos: [13,46] tooltip: "Save selected objects position data as a .txt file to be copied into After Effects."
	
	on copyToClipboardStatic pressed do
		(
			if selection.count ==1 then
				(
				try(
					currentFrameText = "	"+((currentTime as integer)/TicksPerFrame) as string
				
					xPosition =((floor ($.pos.x * 1000)) / 1000)
					yPosition =((floor ($.pos.y * 1000)) / 1000)
					zPosition =((floor ($.pos.z * 1000)) / 1000)

					xPositionMod = xPosition
					yPositionMod = -zPosition
					zPositionMod = yPosition	
						
					xPositionText = "	"+xPositionMod as string
					yPositionText = "	"+yPositionMod as string
					zPositionText = "	"+zPositionMod as string	
								
					setclipboardText((headderText as string)+("
")+(currentFrameText as string)+(xPositionText as string)+(yPositionText as string)+(zPositionText as string)+(footerText as string))
					print clipboardString as string
		
					messagebox "AE keyframe Data has been
copied to your clipboard."
				)
				catch(Messagebox "Error")
			)
			else (messagebox "You must select one (1) object")
		)
	
	on saveTextStatic pressed do
		(
			if selection.count == 1 then
			(
				try
					(
					saveForAEFileStaticName = GetSaveFileName filename:"c:/idontexist/StaticPositionForAE.txt" types:"text(*.txt)"
					if saveForAEFileStaticName != undefined then
					 (
						saveForAEFileStatic = createfile saveForAEFileStaticName
					
						currentFrameText = "	"+((currentTime as integer)/TicksPerFrame) as string
						print currentFrameText
					
						xPosition =((floor ($.pos.x * 1000)) / 1000)
						yPosition =((floor ($.pos.y * 1000)) / 1000)
						zPosition =((floor ($.pos.z * 1000)) / 1000)

						xPositionMod = xPosition
						yPositionMod = -zPosition
						zPositionMod = yPosition	
							
						xPositionText = "	"+xPositionMod as string
						yPositionText = "	"+yPositionMod as string
						zPositionText = "	"+zPositionMod as string	
									
						format "%\n" headderText to:saveForAEFileStatic
						format "%" currentFrameText to:saveForAEFileStatic
						format "%" xPositionText to:saveForAEFileStatic
						format "%" yPositionText to:saveForAEFileStatic
						format "%" zPositionText to:saveForAEFileStatic
						format "%" returnText to:saveForAEFileStatic
						format "%" footerText to:saveForAEFileStatic
						
						close saveForAEFileStatic
						edit saveForAEFileStaticName
						)
					else()	
					)
				catch(Messagebox "unexpected error")
			)
			else (Messagebox "You must select one (1) object")
		)
)

--------------------------------------------------------------
--------------ANIMATED POS ROLLOUT----------------
--------------------------------------------------------------

rollout AnimatedPositionsExporter "Animated Position"
(
	groupBox ObjectsGroup "Object" width:151 height:70 pos: [5,5]
	pickbutton loadUserDefined "Select Object" width:85  pos: [13,22]
	button clearUserDefined "Clear" width:43 pos: [105,22]
	multiListBox userDefinedFileList height:1

	groupBox framesGroup "Frames" width:151 height:70 pos: [5,80]
	spinner framesStartSpinner "" range:[0,99999,0] width:58 type:#integer pos: [13,98]
	spinner framesEndSpinner "To " range:[0,99999,100] width:70 type:#integer pos: [78,98]
	button timeSnap "Snap to Timeline" width: 135 height:20 pos: [13,122]
	
	groupBox Processing "Generation" width:151 height:95 pos: [5,155]
	button processPositions " Export Animated Postition " width: 135 height:40 pos: [13,172]
	label lab1 "Progress:"
	progressbar objProgress   width: 134 height:10 pos: [13,233]
		
	hyperLink aaronDabelow "© 2010  Aaron Dabelow" address:"http://aarondabelow.com/" pos: [7,258]
	button informationButton "?"  width: 20 height:20 pos: [136,256]
	
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
				
				saveForAEFileAnimatedName = GetSaveFileName filename:"c:/idontexist/AnimatedPositionForAE.txt" types:"text(*.txt)"
				if saveForAEFileAnimatedName != undefined then
					(
					saveForAEFileAnimated = createfile saveForAEFileAnimatedName
						
					deselect
					select theanimatedobject
						
					format "%\n" headderText to:saveForAEFileAnimated
					
					sliderTime = framesStart
						
					totalFrames =(framesEnd-framesStart)
					currentFrame = 0
						
					 for i in framesStart to framesEnd do
						(
						currentFrameText = "	"+((currentTime as integer)/TicksPerFrame) as string
						print currentFrameText
					
						xPosition =((floor ($.pos.x * 1000)) / 1000)
						yPosition =((floor ($.pos.y * 1000)) / 1000)
						zPosition =((floor ($.pos.z * 1000)) / 1000)

						xPositionMod = xPosition
						yPositionMod = -zPosition
						zPositionMod = yPosition	
							
						xPositionText = "	"+xPositionMod as string
						yPositionText = "	"+yPositionMod as string
						zPositionText = "	"+zPositionMod as string	
									
						format "%" currentFrameText to:saveForAEFileAnimated
						format "%" xPositionText to:saveForAEFileAnimated
						format "%" yPositionText to:saveForAEFileAnimated
						format "%" zPositionText to:saveForAEFileAnimated
						format "%" returnText to:saveForAEFileAnimated
						
						sliderTime =(sliderTime+1)
						
						objProgress.value = 100.*currentFrame/totalFrames
						currentFrame = (currentFrame+1)
						
						)
						
					format "%" footerText to:saveForAEFileAnimated
					close saveForAEFileAnimated
					edit saveForAEFileAnimatedName
						
					objProgress.value = 0
						
					)else()
					
				animationRange = oldAnimationRange 
				SliderTime = oldSliderTime
				redraw = on
				enableSceneRedraw()
				
				)catch(Messagebox "Script Error")
			)else(messagebox"Load object")
		)	
		
	on informationButton pressed do
		(rollout InformationDialog "AE Position Exporter Info"
			(
			bitmap dtbHeadder fileName:"Scripts\DTB\AEX_headder.gif" width: 164 height:47 align:#center
			hyperLink DTBLink "AE Position Exporter v1.0  Help" address:"http://www.aarondabelow.com/pages/AE_Pos_Export.html" align:#center
			label lab4 ""
			label lab5 "To Use 'Static Position':" align:#left
			label lab19 ""
			label lab6 "(1)  Select object whose position you want."  align:#left
			label lab7 "      translated to Adobe After Effects space."  align:#left
			label lab8 "(2)  Choose your export method to AE as"align:#left
			label lab9 "      data to be pasted from clipboard, or as"align:#left
			label lab10 "      a .txt file to be copied and pasted or" align:#left
			label lab11 "      shared." align:#left
			label lab12 ""
			label lab13 "To Use 'Animated Position':" align:#left
			label lab14 ""
			label lab15 "(1)  Select object with the floater." align:#left
			label lab16 "(2)  Set your desired range to export." align:#left
			label lab17 "(3)  Push the 'Export Animated Position'" align:#left
			label lab18 "      and set your export location." align:#left
			label lab22 "(4)  Open the saved .txt file, and copy" align:#left
			label lab23 "      and paste its contents into AE" align:#left
			label lab24 ""
			hyperLink aaronDabelow "Aaron Dabelow" address:"http://aarondabelow.com/" align:#center
			label lab21 "theonlyaaron@gmail.com"
			)
		createDialog InformationDialog 225 468
		)
)

--------------------------------------------------------------
--------------FLOATER CONSTRUCTION----------------
--------------------------------------------------------------

AEPositionExporter=newrolloutfloater "AE Position Exporter" 175 414 198 82
addrollout StaticPositionExporter AEPositionExporter
addrollout AnimatedPositionsExporter AEPositionExporter