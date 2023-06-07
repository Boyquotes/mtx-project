extends Node2D

export var move_speed = 500;

const Level = preload("res://src/scenes/world_map/Level.gd")

var _moving = true
var _dir = 1
var _level: Level
onready var _path = $Path2D/PathFollow2D

func _ready():
	_path.offset = 0

func _process(delta):
	if _moving: return
	
	if Input.is_action_just_pressed("spawn_1") and _level.level_nr > 1:
		_dir = -1
		_moving = true
	elif Input.is_action_just_pressed("spawn_3") and _level.level_nr < GameData.amount_of_levels:
		_dir = 1
		_moving = true

func _physics_process(delta):
	if _moving:	
		_path.offset += move_speed * delta * _dir

func _on_LevelDetector_area_entered(area):
	_level = area
	_moving = false
	print(_level.level_nr)
