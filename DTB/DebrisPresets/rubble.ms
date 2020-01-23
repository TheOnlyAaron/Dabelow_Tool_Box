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