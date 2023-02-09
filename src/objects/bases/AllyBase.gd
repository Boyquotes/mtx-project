extends "res://src/objects/bases/Base.gd"

var _units: Array

signal game_over	

func _create_unit(unit: PackedScene):
	var new_unit : UnitTypes.UNIT_TYPE = unit.instance()
	if Global.GameManager.get_current_money() >= new_unit.cost:
		Global.GameManager.change_money_by(-new_unit.cost)
		new_unit.make_unit_ally()
		new_unit.global_position = $Spawnpoint.global_position
		_spawn_unit(new_unit)
	else:
		new_unit.queue_free()

func _process(delta):
	if Input.is_action_just_pressed("spawn_1"):
		_create_unit(UnitTypes.selected_units[0]);
	elif Input.is_action_just_pressed("spawn_2"):
		_create_unit(UnitTypes.selected_units[1]);
	elif Input.is_action_just_pressed("spawn_3"):
		_create_unit(UnitTypes.selected_units[2]);

func _die():
	emit_signal("game_over")
	queue_free()
