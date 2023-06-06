extends "res://src/objects/units/ranged_units/RangedProjectile.gd"

export var curve_height = 1.5
export var gravity_strenght = 0.01
export var rotation_speed = 0.05

var _acceleration = Vector2.ZERO

func shoot(damage: int, target: Vector2, is_enemy: bool):
	if target == null: 
		queue_free()
	else:
		var frames_before_hitting_ground = (curve_height/gravity_strenght)*2
		hspeed = (target.x - global_position.x)/frames_before_hitting_ground
		_acceleration = Vector2(hspeed, curve_height*-1)
		$Sprite.rotation_degrees += randi()%180
		
		_damage = damage
		if is_enemy: 
			_direction = -1
			$ExplosionHitbox.set_collision_mask_bit(2, true)
		else:
			$ExplosionHitbox.set_collision_mask_bit(3, true)
		_shot = true
		
		$ExplosionHitbox.visible = false
		$Sprite.visible = true
		

		
func _move():
	global_position += _acceleration * Global.time_scale
	_acceleration.y += gravity_strenght * Global.time_scale
	$Sprite.rotation_degrees += rotation_speed

func _hit():
	pass


func _on_GroundDetector_body_entered(body):
	set_physics_process(false)
	$Explode.play("explode")
	$Explosion.play()
	for body in $ExplosionHitbox.get_overlapping_bodies():
		body.take_damage(_damage)


func _on_Explode_animation_finished(anim_name):
	queue_free()
