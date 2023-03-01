extends Control

onready var _start_coinels = Currency.current_coinels

func _ready():
	visible = false

func _end_game():
	get_tree().paused = true
	$Coinels.text = "Coinels earned: " + str(Currency.current_coinels - _start_coinels)
	Global.first_time = false
	visible = true
	
func _defeat():
	$GameOverText.text = "You lost!"
	
func _victory():
	$GameOverText.text = "You win!"

func _on_AllyBase_game_over():
	_defeat()
	_end_game()

func _on_EnemyBase_game_over():
	_victory()
	_end_game()

func _on_BackToMenuButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://src/scenes/title_screen/TitleScreen.tscn")
