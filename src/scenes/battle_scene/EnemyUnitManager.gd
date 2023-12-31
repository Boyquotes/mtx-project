extends Node

const ENEMY_BASE = preload("res://src/objects/bases/EnemyBase.gd")

# needs enemy base as parent
onready var _zones: = get_children()
onready var _level_data = "res://data/level_data/LevelData%s.txt" % str(Global.level_playing) 
onready var _base: ENEMY_BASE = get_parent().get_node("EnemyBase")

var _time_waves: Array
var _base_dmg_waves: Array
var _end_waves: Array

var _next_wave: Wave
var _next_wave_time = 1
var _time = 0
var _is_sending = false
var _reached_max_time_wave = false
var _current_time_wave_index = 0

var _unit_queues: Array

# INITIALIZING WAVES AND LEVELS
class Wave:
	var wave_type = "t"
	var zone_nr = 0
	var time_delay = 10
	var delay_between_enemies = 1.0
	var enemies: Array = [UnitTypes.MELEE_UNIT]
	
	func _init(wave_type: String, zone_nr: int, time_delay: int, delay_between_enemies: float, enemies: Array):
		self.wave_type = wave_type
		self.zone_nr = zone_nr
		self.time_delay = time_delay
		self.delay_between_enemies = delay_between_enemies
		self.enemies = enemies
	
func _ready():
	for i in range(get_child_count()):
		_unit_queues.append([])
		
	randomize()
	_parse_level_data()
	_zones.sort()
	
	_next_wave = _time_waves[0]
	_next_wave_time = _next_wave.time_delay
	

func _physics_process(delta):
	_spawn_from_queues()
	
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

### SPAWN AND QUEUE MANAGEMENT
func append_unit_to_queues(unit_name: String, zone_nr: int):
	_unit_queues[zone_nr].append(unit_name)

func append_unit_in_front_queues(unit_name: String, zone_nr: int):
	_unit_queues[zone_nr].insert(0,unit_name)
	
func empty_queue(zone_nr:int):
	_unit_queues[zone_nr] = []

func _spawn_unit(unit_name: String, zone_nr: int):
	var new_unit : UnitTypes.UNIT_TYPE = UnitTypes.name_to_unit_dict[unit_name].instance()
	new_unit.make_unit_enemy()
	new_unit.position = _zones[zone_nr].global_position
	add_child(new_unit)

func _spawn_next_unit_in_queue(zone_nr):
	var unit = _unit_queues[zone_nr].front()
	_spawn_unit(unit, zone_nr)
	_unit_queues[zone_nr].remove(0)

func _spawn_from_queues():
	for i in range(_unit_queues.size()):
		var q: Array = _unit_queues[i]
		if q.empty(): continue
		
		if _zones[i].get_overlapping_bodies().size() == 1:
			_spawn_next_unit_in_queue(i)

### WAVE LOGIC		
func _send_wave(wave: Wave, prio = false):
	for i in range(0, wave.enemies.size()):
		var unit_name = wave.enemies[i]
		if prio:
			append_unit_in_front_queues(unit_name, wave.zone_nr)
		else:
			append_unit_to_queues(unit_name, wave.zone_nr)
		if i < wave.enemies.size() - 1:
			yield(get_tree().create_timer(wave.delay_between_enemies), "timeout")

	if wave.wave_type != "b":
		_next_wave_time += _next_wave.time_delay	
	_is_sending = false

func _parse_level_data():
	var file = File.new()
	file.open(_level_data, file.READ)
	assert(file.is_open())
	Global.GameManager.change_money_by(int(file.get_csv_line()[1]))
		
	var amount_of_zones = get_child_count()
	
	while !file.eof_reached():
		var csv = file.get_csv_line()
		var enemies: Array
		for i in range(4, csv.size()):
			enemies.append(csv[i])
		
		var zone_nr = int(csv[1][1])
		assert(zone_nr < amount_of_zones)
		
		var new_wave:Wave = Wave.new(str(csv[0]), zone_nr, int(csv[2]), float(csv[3]), enemies)
		
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
		
