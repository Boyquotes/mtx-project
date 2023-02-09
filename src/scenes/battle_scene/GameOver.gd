extends Control

func _ready():
	visible = false

func _end_game():
	get_tree().paused = true
	visible = true
	
func _defeat():
	$GameOverText.text = "You lost!"
	
func _victory():
	$GameOverText.text = "You wun!"

func _on_AllyBase_game_over():
	_defeat()
	_end_game()

func _on_EnemyBase_game_over():
	_victory()
	_end_game()

func _on_BackToMenuButton_pressed():
	get_tree().change_scene("res://src/scenes/TitleScreen.tscn")
