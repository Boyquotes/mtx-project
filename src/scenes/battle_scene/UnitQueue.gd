extends Node2D

export var spacing = Vector2(0,-150)

var _base
var _units: Array
var _offset = Vector2.ZERO

func _ready():
	_base = get_parent().get_parent().get_node("AllyBase")

func _on_AllyBase_queue_decreased():
	var u = _units.pop_front()
	u.queue_free()
	for s in _units:
		s.global_position -= spacing
	_offset -= spacing

func _on_AllyBase_queue_increased():
	var s = get_node(_base.get_unit_queue()[0].unit_name).duplicate()
	add_child(s)
	s.global_position = global_position + _offset
	_offset += spacing
	s.visible = true
	_units.append(s)
