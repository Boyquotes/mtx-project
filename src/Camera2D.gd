extends Camera2D

export var max_camera_speed = 4
export var camera_acceleration = 0.25
export var margin = 250

var _camera_velocity = 0

func _physics_process(delta):
	var dif = get_global_mouse_position().x - global_position.x
	
	if abs(dif) > margin:
		_camera_velocity += camera_acceleration
		_camera_velocity = min(_camera_velocity, max_camera_speed)
	elif _camera_velocity > 0.1:
		_camera_velocity -= camera_acceleration
		_camera_velocity = max(_camera_velocity, 0)
	global_position.x += _camera_velocity*sign(dif)
