extends "res://src/objects/bases/Base.gd"

var _units: Array

func _ready():
	_type = side.ALLY

func _process(delta):
	if Input.is_action_just_pressed("spawn_1"):
		_spawn_unit(UnitTypes.selected_units[0]);
	elif Input.is_action_just_pressed("spawn_2"):
		_spawn_unit(UnitTypes.selected_units[1]);
	elif Input.is_action_just_pressed("spawn_3"):
		_spawn_unit(UnitTypes.selected_units[2]);
