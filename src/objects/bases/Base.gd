extends StaticBody2D

enum side {ALLY, ENEMY}

export var max_health_points = 10
export var no_collision_with_allies = true

onready var _initial_hp_bar_size = $ColorRect.rect_size.y
onready var _current_hp = max_health_points
signal hp_changed
	
func take_damage(damage):
	_current_hp -= damage
	$ColorRect.rect_size = Vector2($ColorRect.rect_size.x, max(0,_current_hp) * (_initial_hp_bar_size/max_health_points))
	if _current_hp <= 0:
		_die()
	else:
		emit_signal("hp_changed")

func _die():
	pass
	
func is_enemy():
	return false

func get_hp():
	return _current_hp
	
func get_hp_percent():
	return _current_hp*100/max_health_points
