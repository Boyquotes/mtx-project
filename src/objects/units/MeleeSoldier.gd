extends "res://src/objects/units/Unit.gd"

func _attack():
	scale.y *= 3
	_deal_damage()
	yield(get_tree().create_timer(0.5), "timeout")
	scale.y /= 3
