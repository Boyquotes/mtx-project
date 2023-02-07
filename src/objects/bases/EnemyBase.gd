extends "res://src/objects/bases/Base.gd"

func _ready():
	_type = side.ENEMY
	$Timer.one_shot = false
	$Timer.start(5)
	
	

func _on_Timer_timeout():
	var r = randi()%4
	var unit_type: PackedScene
	
	match(r):
		0:
			unit_type = UnitTypes.MELEE_UNIT
		1:
			unit_type = UnitTypes.TANKY_UNIT
		2:
			unit_type = UnitTypes.FAST_UNIT
		3:
			unit_type = UnitTypes.TANKY_UNIT
		_:
			unit_type = UnitTypes.MELEE_UNIT
			
	_spawn_unit(unit_type)
