extends Node2D

enum unit_names {PLAIN_BAGEL, NEW_YORK_BAGEL, POPPY_SEED_BAGEL, CYMBAGEL, BAGELATINE, GRENADEL, BAEGEL, TREBUCHAGEL, BLANK, EVERYTHING_BAGEL}

var _selected_units: Array

func _ready():
	$PlayButton.visible = false

func select_unit(unit_name: int):
	if _selected_units.size() == 3:
		return false
		
	_selected_units.append(unit_name)
	$PlayButton.visible = _selected_units.size() == 3
	return true
	
func unselect_unit(unit_name: int):
	for unit_type in _selected_units:
		if unit_type == unit_name:
			_selected_units.erase(unit_name)
	$PlayButton.visible = _selected_units.size() == 3

func _on_PlayButton_pressed():
	var selected_units: Array
	
	for unit_type in _selected_units:
		selected_units.append(UnitTypes.name_to_unit_dict[UnitTypes.unit_names[unit_type]])
		
	UnitTypes.selected_units = selected_units
	get_tree().change_scene("res://src/scenes/battle_scene/BattleScene.tscn")
