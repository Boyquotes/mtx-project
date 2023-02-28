extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$CurrencyMonitor.update_values()


func _on_Back_pressed():
	get_tree().change_scene("res://src/scenes/title_screen/TitleScreen.tscn")
