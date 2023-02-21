extends Area2D

export var hspeed = 1

var _damage: int
var _shot = false
var _direction = 1

func shoot(damage: int, target: KinematicBody2D, is_enemy: bool):
	_damage = damage
	if is_enemy: 
		_direction = -1
		set_collision_mask_bit(2, true)
	else:
		set_collision_mask_bit(3, true)
	_shot = true
	
func _physics_process(delta):
	if _shot:
		_move()
		
func _move():
	pass

func _on_RangedProjectile_body_entered(body):
	body.take_damage(_damage)
	queue_free()