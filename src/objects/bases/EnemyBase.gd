extends "res://src/objects/bases/Base.gd"

func _ready():
	$Timer.one_shot = false
	$Timer.start(4)
	
func _create_unit(unit: PackedScene):
	var new_unit : UnitTypes.UNIT_TYPE = unit.instance()
	new_unit.make_unit_enemy()
	new_unit.global_position = $Spawnpoint.global_position
	_spawn_unit(new_unit)

func _on_Timer_timeout():
	var r = randi()%4
	var unit_type: PackedScene
	
	match(r):
		0:
			unit_type = UnitTypes.MELEE_UNIT
		1:
			unit_type = UnitTypes.FAST_UNIT
		2:
			unit_type = UnitTypes.FAST_UNIT
		3:
			unit_type = UnitTypes.TANKY_UNIT
		_:
			unit_type = UnitTypes.MELEE_UNIT
			
	_create_unit(unit_type)
