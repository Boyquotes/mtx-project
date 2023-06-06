extends "res://src/objects/units/melee_units/BasicMeleeUnit.gd"

var _base_type 

func _ready():
	_base_type = load("res://src/objects/bases/Base.gd")

func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation == "attack":
		if $AnimatedSprite.frame == 0:
			$Attack.play()
		if $AnimatedSprite.frame == damage_frame:
			var target = _find_closest_target()
			if target == null or target is _base_type: return
			target.switch_sides()
			
			
		


