extends StaticBody2D

enum side {ALLY, ENEMY}

export var health_points = 50
export var spawn_delay = 2.0

func _spawn_unit(unit: UnitTypes.UNIT_TYPE):
	Global.GameManager.add_unit(unit)

func _create_unit(unit: PackedScene):
	pass
	
func take_damage(damage):
	health_points -= damage
	$Label.text = str(max(health_points, 0))
	if health_points < 0:
		queue_free()

