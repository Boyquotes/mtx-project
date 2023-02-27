extends Control

export var TitleScreen : PackedScene

export var lootboxCostC0 = 100
export var lootboxCostC1 = 50

func _ready():
	$LootBox_Purchase.visible = false

func _on_BuyLB_c0_button_up():
	pass # Replace with function body.

func _on_BuyLB_c1_button_up():
	pass # Replace with function body.

func _on_Back_button_up():
	get_tree().change_scene("res://src/scenes/TitleScreen.tscn")


func _on_BuyLB_button_up():
	$LootBox_Purchase.visible = true


func _on_LB_close_button_up():
	$LootBox_Purchase.visible = false
