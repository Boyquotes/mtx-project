extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var animation_player

# Called when the node enters the scene tree for the first time.
func _ready():
	# Find the AnimationPlayer node in the scene
	animation_player = get_node("AnimationPlayer")

	# Start playing the animation
	animation_player.play("Lootbox_Open_Anim")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_button_up():
	get_tree().change_scene("res://src/scenes/lootbox_scene/LootboxMenu.tscn")


