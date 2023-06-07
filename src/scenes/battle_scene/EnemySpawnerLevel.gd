extends Node

const ENEMY_BASE = preload("res://src/objects/bases/EnemyBase.gd")
const GAME_MANAGER = preload("res://src/utility/GameManager.gd")

# needs enemy base as parent
onready var _base: ENEMY_BASE = get_parent().get_node("EnemyBase")
onready var _gm: GAME_MANAGER = get_parent().get_node("GameManager")
onready var _level_data = "res://data/level_data/LevelData%s.txt" % str(Global.level_playing) 

var _time_waves: Array
var _base_dmg_waves: Array
var _end_waves: Array

var _next_wave: Wave
var _next_wave_time = 1
var _time = 0
var _is_sending = false
var _reached_max_time_wave = false
var _current_time_wave_index = 0

# INITIALIZING WAVES AND LEVELS
class Wave:
	var wave_type = "t"
	var time_delay = 10
	var delay_between_enemies = 1.0
	var enemies: Array = [UnitTypes.MELEE_UNIT]
	
	func _init(wave_type: String, time_delay: int, delay_between_enemies: float, enemies: Array):
		self.wave_type = wave_type
		self.time_delay = time_delay
		self.delay_between_enemies = delay_between_enemies
		self.enemies = enemies
	
func _ready():
	if Global.level_playing == -1:
		queue_free()
	randomize()
	_parse_level_data()
	_next_wave = _time_waves[0]
	_next_wave_time = _next_wave.time_delay

func _physics_process(delta):
	if _is_sending: return
	_time += delta * Global.time_scale 
	if _time < _next_wave_time: return
	
	_is_sending = true
	
	_send_wave(_next_wave)
	
	if _reached_max_time_wave:
		# send out random end wave
		var w = randi()%_end_waves.size()
		_next_wave = _end_waves[w]
	else:
		# send out next time wave
		_current_time_wave_index += 1
		_reached_max_time_wave = _current_time_wave_index == _time_waves.size() - 1
		_next_wave = _time_waves[_current_time_wave_index]
	

func _send_wave(wave: Wave, prio = false):
	for i in range(0, wave.enemies.size()):
		var unit_name = wave.enemies[i]
		if prio:
			_base.append_unit_in_front_queue(unit_name)
		else:
			_base.append_unit_to_queue(unit_name)
		if i < wave.enemies.size() - 1:
			yield(get_tree().create_timer(wave.delay_between_enemies), "timeout")

	if wave.wave_type != "b":
		_next_wave_time += _next_wave.time_delay	
	_is_sending = false

func _parse_level_data():
	var file = File.new()
	file.open(_level_data, file.READ)
	assert(file.is_open())
	_gm.change_money_by(int(file.get_csv_line()[1]))
	
	while !file.eof_reached():
		var csv = file.get_csv_line()
		var enemies: Array
		for i in range(3, csv.size()):
			enemies.append(csv[i])
			
		var new_wave:Wave = Wave.new(str(csv[0]), int(csv[1]), float(csv[2]), enemies)
		
		match(new_wave.wave_type):
			"t":
				_time_waves.append(new_wave)
			"b":
				_base_dmg_waves.append(new_wave)
			"e":
				_end_waves.append(new_wave)	
	file.close()

func _on_EnemyBase_hp_changed():
	for i in range(_base_dmg_waves.size() - 1, -1, -1):
		var wave = _base_dmg_waves[i]
		if wave.time_delay < _base.get_hp_percent(): continue
		_send_wave(wave)
		_base_dmg_waves.remove(i)
		
