extends Node

const lootbox_data_file = "res://data/LootBoxChances.txt"
const unit_rarity_data_file = "res://data/UnitRarities.txt"

var _chances: Dictionary
var	_units: Dictionary

var _intervals: Array

var _test: Dictionary

func _ready():
	randomize()
	_parse_unit_rarity_data_file()
	_parse_lootbox_data_file()
	
	_make_intervals()

	_test_rng(100000)

func _make_intervals():
	var total = 0
	for key in _chances.keys():
		total += _chances[key]*100
		_intervals.append(total)
	
	if total > 100:
		print("lootbox chances do not sum to 1")

func _parse_unit_rarity_data_file():
	var file = File.new()
	file.open(unit_rarity_data_file, file.READ)
	while !file.eof_reached():
		# format: NAME,RARITY
		var csv = file.get_csv_line()
		var unit_name = csv[0]
		var rarity = csv[1]
		
		if not rarity in _units.keys(): 
			_units[rarity] = []
			
		if not unit_name in _units[rarity]:
			_units[rarity].append(unit_name)
		
		if not unit_name in _test.keys():
			_test[unit_name] = 0
			
	file.close()

func _parse_lootbox_data_file():
	var file = File.new()
	file.open(lootbox_data_file, file.READ)
	while !file.eof_reached():
		# format: RARITY,CHANCE
		var csv = file.get_csv_line()
		var rarity = csv[0]
		var chance = csv[1]
		
		_chances[rarity] = float(chance)
			
	file.close()
	
func open_lootbox() -> String:
	var r = (randi()%100) + 1
	for i in range(_intervals.size()):
		if not r <= _intervals[i]: continue
		
		var rarity = _chances.keys()[i]
		var w = randi()%_units[rarity].size()
		var unit_name = _units[rarity][w]
		
		return unit_name
	
	return "you should not see this value lol"

func _test_rng(amount: int):
	for i in range(amount):
		var unit = open_lootbox()
		_test[unit] += 1
	
	print("Opened " + str(amount) + " lootboxes:")
	for unit in _test.keys():
		print("Got " + str(_test[unit]) + " = " + str((float(_test[unit])/float(amount))*100) + "% of unit " + unit)

func get_unit_rarity_by_name(name: String):
	for key in _units.keys():
		if name in _units[key]:
			return key
	
