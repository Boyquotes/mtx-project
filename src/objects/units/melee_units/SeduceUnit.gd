extends "res://src/objects/units/melee_units/BasicMeleeUnit.gd"

var _has_seduced = false

func _seduce():
	if _can_attack():
		_find_closest_target().switch_sides()
		_has_seduced = true
		
func _attack():
	if not _has_seduced:
		_seduce()
	else:
		$AnimatedSprite.play("attack")
		_deal_damage()
