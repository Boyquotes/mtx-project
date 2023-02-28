extends Node2D

const MANAGER = preload("res://src/scenes/select_scene/UnitSelectingManager.gd")

var _selected = false

var _manager: MANAGER 

export(MANAGER.unit_names) var unit_type = 0

func _ready():
	# hide if unit is not unlocked yet
	if not UnitTypes.units_unlocked[UnitTypes.unit_names[unit_type]]:
		for child in get_children():
			child.visible = false
		$QuestionMark.visible = true
	else:
		$QuestionMark.visible = false
		
	$ColorRect.visible = false
	
	assert(get_parent() is MANAGER)	
	_manager = get_parent()

	
func is_selected():
	return _selected


func _on_UnitSelectButton_pressed():
	if not _selected:
		if _manager.select_unit(unit_type):
			_selected = true
	else:
		_manager.unselect_unit(unit_type)
		_selected = false

	$ColorRect.visible = _selected
