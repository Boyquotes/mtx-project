extends Node

const ENEMY_BASE = preload("res://src/objects/bases/EnemyBase.gd")

# needs enemy base as parent
onready var _base: ENEMY_BASE = get_parent()

export var min_delay_between_waves = 7
export var max_delay_between_waves = 10

const _wave_data_file = "res://data/endless_data/WaveData.txt"
const _level_data_file = "res://data/endless_data/LevelData.txt"

var _current_level: int
var _all_possible_waves: Array
var _current_possible_waves: Array
var _levels: Dictionary

var _next_wave_time = 1
var _level_time = 0
var _time = 0
var _is_sending = false
var t = 0
signal game_over


# INITIALIZING WAVES AND LEVELS
class Wave:
	var min_level = 0
	var max_level = 10
	var delay_between_enemies = 1.0
	var time_to_next_wave_average = 3.0
	var enemies: Array = [UnitTypes.MELEE_UNIT]
	
	func _init(min_level: int, max_level: int, delay_between_enemies: float, time_to_next_wave_average: float, enemies: Array):
		self.min_level = min_level
		self.max_level = max_level
		self.delay_between_enemies = delay_between_enemies
		self.time_to_next_wave_average = time_to_next_wave_average
		self.enemies = enemies
	
	
# FUNCTION
func _ready():
	if Global.level_playing != -1:
		queue_free()
		
	randomize()
	
	_parse_level_data()
	_parse_wave_data()

	_current_level = 0
	_increase_level()
	
	_update_possible_waves()
	

func _physics_process(delta):
	_time += delta * Global.time_scale
	
	if _time > _level_time:
		_increase_level()
	
	if not _is_sending and _time > _next_wave_time:
		_send_out_wave()
	
		
func _parse_wave_data():
	var file = File.new()
	file.open(_wave_data_file, file.READ)
	while !file.eof_reached():
		var csv = file.get_csv_line()
		var enemies: Array
		for i in range(4, csv.size()):
			enemies.append(csv[i])
			
		var new_wave = Wave.new(int(csv[0]), int(csv[1]), max(float(csv[2]), 0.5), max(float(csv[3]), 3), enemies)
		_all_possible_waves.append(new_wave)
	file.close()
	
	
func _parse_level_data():
	var file = File.new()
	file.open(_level_data_file, file.READ)
	while !file.eof_reached():
		var csv = file.get_csv_line()
		_levels[int(csv[0])] = int(csv[1])
	file.close()
		

func _update_possible_waves():
	_current_possible_waves = []
	for wave in _all_possible_waves:
		if _current_level >= wave.min_level and _current_level <= wave.max_level:
			_current_possible_waves.append(wave)
		
func _send_out_wave():
	_is_sending = true
	if _current_possible_waves.size() == 0: 
		return
	
	# we discard any units left from the previous wave
	_base.empty_queue()
	
	# choose a random wave from the ones possible at this level
	var w = randi()%_current_possible_waves.size()
	var wave: Wave = _current_possible_waves[w]
	
	# add every enemy in the wave to the queue
	for unit_name in wave.enemies:
		_base.add_unit_to_queue_from_name(unit_name)
		yield(get_tree().create_timer(wave.delay_between_enemies), "timeout")
	
	var time_until_next_wave = max(0.5, (1 - randi()%3) + wave.time_to_next_wave_average)
	_next_wave_time += time_until_next_wave
	_is_sending = false


func _increase_level():
	_current_level += 1
	if _current_level == _levels.keys().size():
		_level_time = INF
	else:
		_level_time += _levels[_current_level]
		_update_possible_waves()

