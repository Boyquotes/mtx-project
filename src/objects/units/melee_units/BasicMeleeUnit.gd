extends "res://src/objects/units/Unit.gd"

func _ready():
	$AnimatedSprite.play("idle")

func _attack():
	$AnimatedSprite.play("attack")
	_deal_damage()


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "attack":
		$AnimatedSprite.play("idle")
