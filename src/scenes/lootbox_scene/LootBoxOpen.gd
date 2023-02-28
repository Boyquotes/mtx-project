extends Control

var result


func _ready():
	$AnimationPlayer.play("Lootbox_Open_Anim")
	result = Lootbox.open_lootbox()
	UnitTypes.units_unlocked[result] = true
	
	$Box/LbTop/BoxA.texture = load("res://src/scenes/lootbox_scene/assets/box_" + Lootbox.get_unit_rarity_by_name(result) + ".png")
	$Box/LbTop/BoxA/Label.text = UnitTypes.name_to_in_game_name[result]
	
	match(result):
		"PLAIN_BAGEL": 
			$Box/LbTop/BoxA/PlainBagel.visible = true
		"NEW_YORK_BAGEL": 
			$Box/LbTop/BoxA/NewYork.visible = true
		"POPPY_SEED_BAGEL": 
			$Box/LbTop/BoxA/Poppy.visible = true			
		"CYMBAGEL": 
			$Box/LbTop/BoxA/Cymbagel.visible = true			
		"BAGELATINE": 
			$Box/LbTop/BoxA/Bagelatine.visible = true
		"GRENADEL": 
			$Box/LbTop/BoxA/Grenadel.visible = true			
		"BAEGEL": 
			$Box/LbTop/BoxA/Baegel.visible = true			
		"TREBUCHAGEL": 
			$Box/LbTop/BoxA/Trebuchagel.visible = true			
		"EVERYTHING_BAGEL": 
			$Box/LbTop/BoxA/Everything.visible = true
		"JEBAGEL": 
			$Box/LbTop/BoxA/Jebagel.visible = true
	
func _on_Button_button_up():
	get_tree().change_scene("res://src/scenes/lootbox_scene/LootboxMenu.tscn")


