extends Node2D

var _frame = 0

func _ready():
	if Global.first_time:
		get_tree().paused = true
	else:
		queue_free()

func _process(delta):
	if Input.is_action_just_pressed("left_mouse"):
		get_node(str(_frame)).visible = false
		_frame += 1
		if _frame == 1:
			$PressLeft.visible = false
		if _frame > 5:
			get_tree().paused = false
			queue_free()	
		else:
			get_node(str(_frame)).visible = true
		
