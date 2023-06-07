extends StaticBody2D

enum side {ALLY, ENEMY}

export var max_health_points = 10
export var no_collision_with_allies = true

onready var _initial_hp_bar_size = $ColorRect.rect_size.x
onready var _current_hp = max_health_points
signal hp_changed

func _spawn_unit(unit: KinematicBody2D):
	Global.GameManager.add_unit(unit)

func _create_unit(unit: PackedScene):
	pass
	
func take_damage(damage):
	_current_hp -= damage
	$ColorRect.rect_size = Vector2(max(0,_current_hp) * (_initial_hp_bar_size/max_health_points), $ColorRect.rect_size.y)
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
