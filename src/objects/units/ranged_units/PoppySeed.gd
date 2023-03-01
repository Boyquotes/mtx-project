extends "res://src/objects/units/ranged_units/RangedProjectile.gd"

export var curve_height = 2
export var gravity_strenght = 0.01

var _acceleration = Vector2.ZERO

func shoot(damage: int, target: Vector2, is_enemy: bool):
	.shoot(damage, target, is_enemy)
	if target == null: 
		queue_free()
	else:
		var frames_before_hitting_ground = (curve_height/gravity_strenght)*2
		hspeed = (target.x - global_position.x)/frames_before_hitting_ground
		_acceleration = Vector2(hspeed, curve_height*-1)
		
func _move():
	global_position += _acceleration
	_acceleration.y += gravity_strenght

func _hit():
	queue_free()
