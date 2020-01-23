(
try(closeRolloutFloater ScriptRunner)catch()
)

DTBScripts = getfiles (getdir #maxRoot + "\\Scripts\\DTB\\*.ms")
theCurrentScript=DTBScripts[1]
DTBScriptNames=#()
numberOfScripts = DTBScripts.count

for j in 1 to numberOfScripts do (join DTBScriptNames #((getFilenameFile DTBScripts[j])))

	rollout thefrickenrollout "Choose Script"
(
	dropdownlist theDrop items:DTBScriptNames height:20 width:150 tooltip:"Select your script from the dropdown." pos:[7,7]
	button RunScript "Run Script" width:105 height:30 tooltip:"Launches the chosen script." pos:[7,35] --pos:[10,21]
	button EditScript "Edit" width: 43 height:15 tooltip:"Edits the chosen script." pos:[113,35] --pos:[10,21]
	button refreshScript "Refresh" width: 43 height:15 tooltip:"Edits the chosen script." pos:[113,50] --pos:[10,21]
		
	on theDrop selected i do
		(
		theCurrentScript=DTBScripts[i]
		print theCurrentScript
		)
		
	on RunScript pressed do filein theCurrentScript		
	on EditScript pressed do edit theCurrentScript
	on refreshScript pressed do
	(
	DTBScripts = getfiles (getdir #maxRoot + "\\Scripts\\DTB\\*.ms")
	theCurrentScript=DTBScripts[1]
	DTBScriptNames=#()
	numberOfScripts = DTBScripts.count
			
	for j in 1 to numberOfScripts do (join DTBScriptNames #((getFilenameFile DTBScripts[j])))
			
	theScriptDrop.items = DTBScriptNames
	)		
	
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
ScriptRunner=newrolloutfloater "Script Runner" 175 123 198 82
addrollout thefrickenrollout ScriptRunner
