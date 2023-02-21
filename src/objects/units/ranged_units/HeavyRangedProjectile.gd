extends "res://src/objects/units/ranged_units/RangedProjectile.gd"

export var pierce = 3

func _move():
	global_position.x += hspeed

func _hit():
	pierce -= 1
	if pierce == 0: queue_free()
