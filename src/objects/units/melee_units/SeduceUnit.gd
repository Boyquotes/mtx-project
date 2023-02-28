extends "res://src/objects/units/melee_units/BasicMeleeUnit.gd"

func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation == "attack" and $AnimatedSprite.frame == damage_frame:
		var target = _find_closest_target()
		if target == null: return
		target.switch_sides()
		


