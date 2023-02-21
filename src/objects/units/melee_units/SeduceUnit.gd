extends "res://src/objects/units/melee_units/BasicMeleeUnit.gd"

var _has_seduced = false
		
func _process(delta):
	if not _has_seduced and _enemy_in_range():
		_find_closest_target().switch_sides()
		_has_seduced = true

