extends Control

export var unitSelectScreen : PackedScene
export var unitBuyScreen : PackedScene


func _on_PlayButton_button_up():
	get_tree().change_scene("res://src/scenes/select_scene/UnitSelectScreen.tscn")


func _on_BuyUnitButton_button_up():
	get_tree().change_scene("res://src/scenes/lootbox_scene/LootboxMenu.tscn")
