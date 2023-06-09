extends "res://src/objects/bases/Base.gd"

func _ready():
	$ColorRect.color = Color.green
		
func _die():
	emit_signal("game_over")
	queue_free()


