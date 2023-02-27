extends Node

func _on_BuyLB_c0_pressed():
	print("result: ", Lootbox.open_lootbox())
	get_tree().change_scene("res://src/scenes/lootbox_scene/LootBoxOpen.tscn")

