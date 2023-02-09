extends StaticBody2D

enum side {ALLY, ENEMY}

export var health_points = 10

func _ready():
	$Label.text = str(max(health_points, 0))

func _spawn_unit(unit: UnitTypes.UNIT_TYPE):
	Global.GameManager.add_unit(unit)

func _create_unit(unit: PackedScene):
	pass
	
func take_damage(damage):
	health_points -= damage
	$Label.text = str(max(health_points, 0))
	if health_points < 0:
		_die()

func _die():
	pass
