extends Area2D

export var available_color = Color.green
export var unavailable_color = Color.red

var _rect

func _ready():
	_rect = $AllyZone/Rect

func _process(delta):
	if _rect.visible:
		if $AllyZone.get_overlapping_bodies().size() <= 1:
			_rect.color = available_color
		else:
			_rect.color = unavailable_color	

func ally_zone_is_available():
	return _rect.color == available_color
	
func show():
	_rect.visible = true	

func hide():
	_rect.visible = false		
