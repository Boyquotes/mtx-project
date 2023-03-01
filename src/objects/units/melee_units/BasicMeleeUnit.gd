extends "res://src/objects/units/Unit.gd"

export var damage_frame = 1

func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation == "attack" and $AnimatedSprite.frame == damage_frame:
		$Attack.play()
		_deal_damage()
