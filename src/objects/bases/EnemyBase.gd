extends "res://src/objects/bases/Base.gd"

export var min_delay_between_waves = 7
export var max_delay_between_waves = 10
export var time_for_level_increase = 50


const _wave_data_file = "res://src/utility/Waves.txt"


var _current_level = 0
var _waves: Array
var _current_possible_waves: Array


signal game_over


# SENDING OUT WAVES OF ENEMIES
class Wave:
	var min_level = 0
	var max_level = 10
	var delay_between_enemies = 1.0
	var enemies: Array = [UnitTypes.MELEE_UNIT]
	
	func _init(min_level: int, max_level: int, delay_between_enemies: float, enemies: Array):
		self.min_level = min_level
		self.max_level = max_level
		self.delay_between_enemies = delay_between_enemies
		self.enemies = enemies
	

func _parse_wave_data():
	var file = File.new()
	file.open(_wave_data_file, file.READ)
	while !file.eof_reached():
		var csv = file.get_csv_line()
		var enemies: Array
		for i in range(3, csv.size()):
			enemies.append(csv[i])
			
		var new_wave = Wave.new(int(csv[0]), int(csv[1]), float(csv[2]), enemies)
		_waves.append(new_wave)


func _update_possible_waves():
	_current_possible_waves = []
	for wave in _waves:
		if _current_level >= wave.min_level and _current_level <= wave.max_level:
			_current_possible_waves.append(wave)
	
	
# SPAWNING UNITS 
func _send_out_wave():
	if _current_possible_waves.size() == 0: 
		print("no wave to send out at level ", _current_level)
		return
		
	var w = randi()%_current_possible_waves.size()
	var wave: Wave = _current_possible_waves[w]
	
	for unit_name in wave.enemies:
		var unit = _create_unit_from_name(unit_name)
		_spawn_unit(unit)
		yield(get_tree().create_timer(wave.delay_between_enemies), "timeout")
	
	var time_until_next_wave = randi()%(max_delay_between_waves - min_delay_between_waves) + min_delay_between_waves
	$WaveTimer.start(time_until_next_wave)


func _create_unit_from_name(unit_name: String) -> UnitTypes.UNIT_TYPE:
	var new_unit : UnitTypes.UNIT_TYPE = UnitTypes.name_to_unit_dict[unit_name].instance()
	new_unit.make_unit_enemy()
	new_unit.global_position = $Spawnpoint.global_position
	return new_unit
	
	
# FUNCTION
func _ready():
	randomize()
	$LevelIncreaseTimer.one_shot = false
	$LevelIncreaseTimer.start(time_for_level_increase)
	
	_parse_wave_data()
	_update_possible_waves()
	
	$WaveTimer.one_shot = true
	$WaveTimer.start(1)
	
	
func _on_WaveTimer_timeout():
	_send_out_wave()
	
	
func _die():
	emit_signal("game_over")
	queue_free()


func _on_LevelIncreaseTimer_timeout():
	_current_level += 1
	if _current_level == 10:
		$LevelIncreaseTimer.stop()
	_update_possible_waves()
	
