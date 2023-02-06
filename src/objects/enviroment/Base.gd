extends StaticBody2D

enum side {ALLY, ENEMY}

export var health_points = 50
export var spawn_delay = 2.0
export(side) var type = side.ALLY;

func _ready():
	$Timer.one_shot = false
	$Timer.start(spawn_delay)
	
	if type == side.ALLY:
		set_collision_layer_bit(3, true)
	else:
		set_collision_layer_bit(2, true)

func _process(delta):
	if Input.is_action_just_pressed("spawn"):
		_spawn_unit();

func _spawn_unit():
	var new_unit : UnitTypes.UNIT_TYPE = UnitTypes.MELEE_UNIT.instance()
	new_unit.set_ally_or_enemy(type == side.ALLY)
	get_parent().get_node("Units").add_child(new_unit)
	new_unit.global_position = $Spawnpoint.global_position

func _on_Timer_timeout():
	pass
	
func take_damage(damage):
	health_points -= damage
	$Label.text = str(max(health_points, 0))
	if health_points < 0:
		queue_free()

