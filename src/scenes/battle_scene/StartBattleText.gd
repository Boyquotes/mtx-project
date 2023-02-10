extends Node2D

var _stage = 0

func _ready():
	get_tree().paused = true
	$AnimationPlayer.play("Play")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name != "Play": return
	
	yield(get_tree().create_timer(0.25), "timeout")
	match(_stage):
		0:
			$Label.text = "2"
		1:
			$Label.text = "1"
		2:
			$Label.text = "Go!"
			get_tree().paused = false
		3:
			queue_free()
			
	_stage += 1
	$AnimationPlayer.play("RESET")			
	$AnimationPlayer.play("Play")
