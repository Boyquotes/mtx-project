extends Node2D

export var disable_countdown = false

var _stage = 0

func _ready():
	$AnimationPlayer.play("Play")
	if disable_countdown:
		visible = false
		return
	get_tree().paused = true
	

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
