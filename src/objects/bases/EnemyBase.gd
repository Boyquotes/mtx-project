extends "res://src/objects/bases/Base.gd"

signal game_over

func _ready():
	$ColorRect.color = Color.red
	

func _die():
	emit_signal("game_over")
	queue_free()

func is_enemy():
	return true
