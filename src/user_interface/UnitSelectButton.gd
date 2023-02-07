extends Node2D

const MANAGER = preload("res://src/user_interface/UnitSelectingManager.gd")

var _selected = false
var _manager: MANAGER 

export(MANAGER.unit_names) var unit_type = 0

func _ready():
	$ColorRect.visible = _selected
	assert(get_parent() is MANAGER)	
	_manager = get_parent()
	$Label.text = "Button"
	
func _on_Button_pressed():
	if not _selected:
		if _manager.select_unit(unit_type):
			_selected = true
	else:
		_manager.unselect_unit(unit_type)
		_selected = false

	$ColorRect.visible = _selected
	
func is_selected():
	return _selected
