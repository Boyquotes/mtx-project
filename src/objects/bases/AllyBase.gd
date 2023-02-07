extends "res://src/objects/bases/Base.gd"

func _ready():
	_type = side.ALLY

func _process(delta):
	if Input.is_action_just_pressed("spawn_1"):
		_spawn_unit(UnitTypes.MELEE_UNIT);
	elif Input.is_action_just_pressed("spawn_2"):
		_spawn_unit(UnitTypes.TANKY_UNIT);
	elif Input.is_action_just_pressed("spawn_3"):
		_spawn_unit(UnitTypes.HEAVY_UNIT);
	elif Input.is_action_just_pressed("spawn_4"):
		_spawn_unit(UnitTypes.FAST_UNIT);
