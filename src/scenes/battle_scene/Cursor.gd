extends KinematicBody2D

func _process(delta):
	var vec = get_viewport().get_mouse_position() - self.position # getting the vector from self to the mouse
	position = vec
