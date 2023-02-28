extends Node2D

enum unit_names {PLAIN_BAGEL, NEW_YORK_BAGEL, POPPY_SEED_BAGEL, CYMBAGEL, BAGELATINE, GRENADEL, BAEGEL, TREBUCHAGEL, BLANK, EVERYTHING_BAGEL}

var _selected_units: Array

func _ready():
	$PlayButton.visible = false

func select_unit(unit_name: int):
	if _selected_units.size() == 3 or unit_name in _selected_units:
		return false
			
	_selected_units.append(unit_name)
	$PlayButton.visible = _selected_units.size() > 0 
	return true
	
func unselect_unit(unit_name: int):
	for unit_type in _selected_units:
		if unit_type == unit_name:
			_selected_units.erase(unit_name)
	$PlayButton.visible = _selected_units.size() > 0 

func _on_PlayButton_pressed():	
	var units: Array
	for unit in _selected_units:
		units.append(UnitTypes.unit_names[unit])	
	UnitTypes.selected_units = units
	
	get_tree().change_scene("res://src/scenes/battle_scene/BattleScene.tscn")
