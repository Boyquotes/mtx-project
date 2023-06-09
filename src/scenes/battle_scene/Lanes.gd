extends Node2D

func _ready():
	hide()

func show():
	for lane in self.get_children():
		lane.show()
		
func hide():
	for lane in self.get_children():
		lane.hide()
