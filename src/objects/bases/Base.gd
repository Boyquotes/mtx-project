extends StaticBody2D

enum side {ALLY, ENEMY}

export var health_points = 50
export var spawn_delay = 2.0

var _type = side.ALLY;

func _spawn_unit(unit: PackedScene):
	var new_unit : UnitTypes.UNIT_TYPE = unit.instance()
	new_unit.set_ally_or_enemy(_type == side.ALLY)
	get_parent().get_node("Units").add_child(new_unit)
	new_unit.global_position = $Spawnpoint.global_position
	
func take_damage(damage):
	health_points -= damage
	$Label.text = str(max(health_points, 0))
	if health_points < 0:
		queue_free()

