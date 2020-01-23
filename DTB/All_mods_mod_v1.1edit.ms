(
try(closeRolloutFloater globalModifierSwitcher)catch()
)

global selectionSwitcher
global selectionChoice
global validCustomModifier

theCurrentModifier=#TurboSmooth
validationColor=[12,51,140]
tempVar = "undefined"
selectionSwitcher = "scene"
validCustomModifier = false

addModString1 = "modPanel.addModToSelection ( "
addModString2 = ""
addModString3 = " ()) ui:on"

iLoopString1 = "i.modifiers["
iLoopString2 = ""
iLoopString3 = "].enabledInViews = true"
iLoopString4 = "].enabled = false"

rollout thefrickenrollout "Choose Modifier"
(
	label label1 "Select desired modifier:" align:#left
	dropdownlist theDrop items:#("Turbosmooth","Meshsmooth","Subdivide","Shell","Hair and Fur","Flex","Cloth","Push","Optimize") height:20 width:141 tooltip:"Globally overrides selected modifier." 
	label label2 "Enter custom modifier:" align:#left
	label label3 "#" align:#left pos:[12,73]
	edittext theCustomModifier width:132 pos:[20,70]
	button validateModifier "Verify" width:142 height:22 align:#left pos:[11,93]
	label theValidator "Unverified Modifier" align: #left pos:[32,121]
	bitmap theValidatorColor "Bitmap" width:15 height:15 \ 
	bitmap:(bitmap 20 20 color:validationColor) pos:[12,119]

	on validateModifier pressed do
		(
		try(
			testerBox = box isselected: on
			addModString2=(theCustomModifier.text)
			iLoopString2 =(theCustomModifier.text)
			addModStringCombo = addModString1+addModString2+addModString3
			print addModStringCombo
			execute (addModStringCombo)
			delete testerBox
			theValidator.text = "Modifier Passed"
			validationColor=green
			theValidatorColor.bitmap=(bitmap 20 20 color:validationColor)
			validCustomModifier = true
			)
			Catch
			(
			thecustomModifier.text = ""
			delete testerBox
			theValidator.text = "Modifier Failed"
			validationColor=red
			theValidatorColor.bitmap=(bitmap 20 20 color:validationColor) 
			validCustomModifier = false
			)
		)
	
	on theDrop selected i do
	(
	if i == 1 then(theCurrentModifier=#TurboSmooth)else()
	if i == 2 then(theCurrentModifier=#meshsmooth)else()
	if i == 3 then(theCurrentModifier=#subdivide)else()
	if i == 4 then(theCurrentModifier=#Shell)else()
	if i == 5 then(theCurrentModifier=#Hair_and_fur)else()
	if i == 6 then(theCurrentModifier=#Flex)else()
	if i == 7 then(theCurrentModifier=#Cloth)else()
	if i == 8 then(theCurrentModifier=#Push)else()
	if i == 9 then(theCurrentModifier=#Optimize)else()
	)
)

rollout thefrickenrollout3 "Choose Selection"
(
	checkBox checkEntireScene "Entire Scene" align:#left  checked:true
	checkBox checkCurrentSelection "Current Selection" align:#left
	
	
	on checkEntireScene changed checkEntireSceneState do
		(
		if checkEntireScene.state == true then
			(
			checkCurrentSelection.state = false
			selectionSwitcher = "scene"
			)
		else 
			(
			checkCurrentSelection.state = True
			selectionSwitcher = "selection"
			)
		)
	
	on checkCurrentSelection changed checkCurrentSelectionState do
		(
		if checkCurrentSelection.state == true then
			(
			checkEntireScene.state = false
			selectionSwitcher = "selection"
			)
		else 
			(
			checkEntireScene.state = True	
			selectionSwitcher = "scene"
			)
		)
)

rollout thefrickenrollout2 "Modify Modifier"
(
	
	button allModsOn "All mods on" width:151 height:20
	button allModsOff "All mods off" width:151 height:20
	button allModsOnInView "All mods on in view" width:151 height:20
	button allModsOffInView  "All mods off in view" width:151 height:20
	
	on allModsOn pressed do(
	if selectionSwitcher == "selection" then(selectionChoice = selection)else(selectionChoice = objects)
	for i in selectionChoice do try 
	(
		i.modifiers[theCurrentModifier].enabledInViews = true
		i.modifiers[theCurrentModifier].enabled = true
		setCommandPanelTaskMode #create
		setCommandPanelTaskMode #modify
	)
	catch ()
	)
	
	on allModsOff pressed do(
	if selectionSwitcher == "selection" then(selectionChoice = selection)else(selectionChoice = objects)
	for i in selectionChoice do
	try 
	(
		if validCustomModifier == false
			then
				(
				i.modifiers[theCurrentModifier].enabledInViews = true
				i.modifiers[theCurrentModifier].enabled = false
				setCommandPanelTaskMode #create
				setCommandPanelTaskMode #modify	
				)
			else
				(
				iLoopStringCombo = (iLoopString1+iLoopString2+iLoopString3)
				iLoopStringComboB = (iLoopString1+iLoopString2+iLoopString4)
				print iLoopStringCombo
				print iLoopStringComboB
		
				execute iLoopStringCombo
				execute iLoopStringComboB	
				)
	)
	catch ()
	)
	
	on allModsOnInView pressed do(
	if selectionSwitcher == "selection" then(selectionChoice = selection)else(selectionChoice = objects)
	for i in selectionChoice do try
	(
		i.modifiers[theCurrentModifier].enabledInViews = false
		i.modifiers[theCurrentModifier].enabled = true
		i.modifiers[theCurrentModifier].enabledInRenders = true
		setCommandPanelTaskMode #create
		setCommandPanelTaskMode #modify
	)
	catch ()
	)
	
	on allModsOffInView pressed do(
	if selectionSwitcher == "selection" then(selectionChoice = selection)else(selectionChoice = objects)
	for i in selectionChoice do try
	(
		i.modifiers[theCurrentModifier].enabledInViews = true
		i.modifiers[theCurrentModifier].enabled = true
		i.modifiers[theCurrentModifier].enabledInRenders = false
		setCommandPanelTaskMode #create
		setCommandPanelTaskMode #modify
	)
	catch ()
	)
	
	hyperLink aaronDabelow "© 2010  Aaron Dabelow" address:"http://aarondabelow.com/" tooltip:"www.aarondabelow.com"
	button informationButton "?" pos: [136,105] width: 20 height:20  tooltip:"Information"
		on informationButton pressed do
		(
		try(closerolloutfloater InformationDialog)catch()
		rollout InformationDialog "DTB Info"
			(
			hyperLink DTBLink "Modifier Modifier info" address:"http://www.aarondabelow.com" align:#center
			label labSpace1 ""
			hyperLink aaronDabelow "Aaron Dabelow" address:"http://aarondabelow.com/" align:#center
			label lab6 "theonlyaaron@gmail.com"
			label labSpace2 ""
			)
		createDialog InformationDialog 175 100
	)
)
globalModifierSwitcher=newrolloutfloater "globalModifierSwitcher" 175 400 198 82
addrollout thefrickenrollout globalModifierSwitcher
addrollout thefrickenrollout3 globalModifierSwitcher
addrollout thefrickenrollout2 globalModifierSwitcher
