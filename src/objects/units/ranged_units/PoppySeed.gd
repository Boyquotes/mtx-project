extends "res://src/objects/units/ranged_units/RangedProjectile.gd"

export var curve_height = 2
export var gravity_strenght = 0.01

var _acceleration = Vector2.ZERO

func shoot(damage: int, target: KinematicBody2D, is_enemy: bool):
	.shoot(damage, target, is_enemy)
	
	var frames_before_hitting_ground = (curve_height/gravity_strenght)*2
	hspeed = (target.global_position.x - global_position.x)/frames_before_hitting_ground
	_acceleration = Vector2(hspeed, curve_height*-1)
	
func _move():
	global_position += _acceleration
	_acceleration.y += gravity_strenght
