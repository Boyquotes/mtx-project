extends "res://src/objects/bases/Base.gd"

var _unit_queue: Array
signal game_over

# FUNCTION
func _ready():
	$ColorRect.color = Color.red

func _physics_process(delta):
	if not _unit_queue.empty() and _check_if_room_for_unit():
		_spawn_next_unit_in_queue()

func append_unit_to_queue(unit_name):
	var new_unit : UnitTypes.UNIT_TYPE = UnitTypes.name_to_unit_dict[unit_name].instance()
	new_unit.make_unit_enemy()
	new_unit.global_position = $Spawnpoint.global_position
	_unit_queue.append(new_unit)

func append_unit_in_front_queue(unit_name):
	var new_unit : UnitTypes.UNIT_TYPE = UnitTypes.name_to_unit_dict[unit_name].instance()
	new_unit.make_unit_enemy()
	new_unit.global_position = $Spawnpoint.global_position
	_unit_queue.insert(0,new_unit)
	
func empty_queue():
	_unit_queue = []
		
func _spawn_next_unit_in_queue():
	var unit = _unit_queue.front()
	_spawn_unit(unit)
	_unit_queue.remove(0)
	
func _die():
	emit_signal("game_over")
	queue_free()

func _check_if_room_for_unit():
	for unit in $CheckForUnits.get_overlapping_bodies():
		if not unit.no_collision_with_allies: return false
	return true
	
func is_enemy():
	return true
