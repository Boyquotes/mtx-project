extends Node2D

var _money = 0

signal money_changed

func _ready():
	MainMenuMusic.stop_main_music()
	Global.GameManager = self
	emit_signal("money_changed")


func get_current_money():
	return _money
	
func change_money_by(value):
	_money += value
	if value > 0: 
		Currency.current_coinels += value*3
	emit_signal("money_changed")

func add_unit(unit: UnitTypes.UNIT_TYPE):
	add_child(unit)
	
func _process(delta):
	if Input.is_action_just_pressed("space"):
		Global.time_scale = Global.sped_up_time_scale
	elif Input.is_action_just_released("space"):
		Global.time_scale = Global.default_time_scale

