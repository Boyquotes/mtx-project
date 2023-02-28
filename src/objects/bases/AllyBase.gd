extends "res://src/objects/bases/Base.gd"

var _units: Array
var _unit_queue : Array
var _can_spawn_unit = true

signal game_over	
signal queue_changed

func _add_unit_to_queue(unit: UnitTypes.UNIT_TYPE):
	_unit_queue.append(unit)
	emit_signal("queue_changed")
	
func _pop_unit_from_queue() -> UnitTypes.UNIT_TYPE:
	var unit = _unit_queue.front()
	_unit_queue.remove(0)
	emit_signal("queue_changed")
	return unit

func _spawn_next_unit_in_queue():
	_spawn_unit(_pop_unit_from_queue())
	
func get_unit_queue() -> Array:
	return _unit_queue
	
func _create_unit(unit: PackedScene):
	var new_unit : UnitTypes.UNIT_TYPE = unit.instance()
	if Global.GameManager.get_current_money() >= new_unit.cost:
		Global.GameManager.change_money_by(-new_unit.cost)
		new_unit.make_unit_ally()
		new_unit.global_position = $Spawnpoint.global_position
		_add_unit_to_queue(new_unit)
	else:
		new_unit.queue_free()

func _process(delta):
	if Input.is_action_just_pressed("spawn_1"):
		_create_unit(UnitTypes.selected_units[0]);
	elif Input.is_action_just_pressed("spawn_2") and UnitTypes.selected_units.size() > 1:
		_create_unit(UnitTypes.selected_units[1]);
	elif Input.is_action_just_pressed("spawn_3") and UnitTypes.selected_units.size() > 2:
		_create_unit(UnitTypes.selected_units[2]);
		
func _check_if_room_for_unit():
	for unit in $CheckForAllyUnits.get_overlapping_bodies():
		if not unit.no_collision_with_allies: return false
	return true
		
func _physics_process(delta):
	if not _unit_queue.empty() and _check_if_room_for_unit():
		_spawn_next_unit_in_queue()
		
func _die():
	emit_signal("game_over")
	queue_free()

