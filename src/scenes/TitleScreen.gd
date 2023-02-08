extends Control

export var unitSelectScreen : PackedScene
export var unitBuyScreen : PackedScene


func _on_PlayButton_button_up():
	get_tree().change_scene(unitSelectScreen.resource_path)
