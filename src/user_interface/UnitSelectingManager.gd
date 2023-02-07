extends Node2D

enum unit_names {PLAIN_BAGEL, NEW_YORK_BAGEL, POPPY_SEED_BAGEL, CYMBAGEL, BAGELATINE, GRENADEL, BAEGEL, TREBUCHAGEL, BLANK, EVERYTHING_BAGEL}

var name_to_unit_dict = {
	unit_names.PLAIN_BAGEL: UnitTypes.MELEE_UNIT,
	unit_names.NEW_YORK_BAGEL: UnitTypes.TANKY_UNIT,
	unit_names.POPPY_SEED_BAGEL: UnitTypes.BASIC_RANGED_UNIT,
	unit_names.CYMBAGEL: UnitTypes.HEAVY_UNIT,
	unit_names.BAGELATINE: UnitTypes.FAST_UNIT,
	unit_names.GRENADEL: UnitTypes.MELEE_UNIT,
	unit_names.BAEGEL: UnitTypes.SEDUCE_UNIT,
	unit_names.TREBUCHAGEL: UnitTypes.HEAVY_RANGED_UNIT,
	unit_names.BLANK: UnitTypes.MELEE_UNIT,
	unit_names.EVERYTHING_BAGEL: UnitTypes.MELEE_UNIT,
}

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
		selected_units.append(name_to_unit_dict[unit_type])
		
	UnitTypes.selected_units = selected_units
	get_tree().change_scene("res://src/scenes/BattleScene.tscn")
