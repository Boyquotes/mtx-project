extends Node2D

export var speed = 1.0

func play(number):
	$Label.text = "+" + str(number) + " dough"
	$DeathAnimation.play("DeathAnimation")
	
func _physics_process(delta):
	global_position.y -= speed
	
func _on_DeathAnimation_animation_finished(anim_name):
	if anim_name == "DeathAnimation":
		queue_free()
