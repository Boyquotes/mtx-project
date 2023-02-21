extends "res://src/objects/units/Unit.gd"

const PROJECTILE = preload("res://src/objects/units/ranged_units/RangedProjectile.gd")

export var shoot_projectile_frame = 1
export(PackedScene) var projectile

func _shoot_projectile():
	var target = _find_closest_target()
	if target == null: return
	
	var new_projectile: PROJECTILE = projectile.instance()
	new_projectile.global_position = global_position
	get_parent().add_child(new_projectile)
	new_projectile.shoot(attack_damage, target, sign(move_speed) == -1)

func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation == "attack" and $AnimatedSprite.frame == shoot_projectile_frame:
		_shoot_projectile()
