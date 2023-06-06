extends "res://src/objects/units/Unit.gd"

const PROJECTILE = preload("res://src/objects/units/ranged_units/RangedProjectile.gd")

var _base_type

export var shoot_projectile_frame = 1
export(PackedScene) var projectile

func _ready():
	_base_type = load("res://src/objects/bases/Base.gd")
	
func _shoot_projectile():
	var new_projectile: PROJECTILE = projectile.instance()
	new_projectile.global_position = global_position
	get_parent().add_child(new_projectile)
	new_projectile.shoot(attack_damage, _target_pos, sign(move_speed) == -1)

func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation == "attack" and $AnimatedSprite.frame == shoot_projectile_frame:
		_shoot_projectile()
