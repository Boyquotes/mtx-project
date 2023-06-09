extends Node2D

const LANE = preload("res://src/scenes/battle_scene/Lane.gd")
const LANES = preload("res://src/scenes/battle_scene/Lanes.gd")

onready var _lanes: LANES = get_parent().get_node("Lanes")
onready var _hover_sprite: Sprite = $UnitSprites/PLAIN_BAGEL
onready var _cursor = $Cursor

var _units: Array
var _can_spawn_unit = true
var _selected_units : Array
var _hover_area: Area2D

func _ready():
	for unit_type in UnitTypes.selected_units:
		_selected_units.append(unit_type)	

	
func _process(delta):
	if Input.is_action_just_pressed("right_mouse"):
		_hover_sprite.visible = false
		_lanes.hide()
	elif Input.is_action_just_pressed("spawn_1"):
		_hover_with_unit(_selected_units[0]);
	elif Input.is_action_just_pressed("spawn_2") and _selected_units.size() > 1:
		_hover_with_unit(_selected_units[1]);
	elif Input.is_action_just_pressed("spawn_3") and _selected_units.size() > 2:
		_hover_with_unit(_selected_units[2]);
	elif Input.is_action_just_pressed("spawn_4") and _selected_units.size() > 3:
		_hover_with_unit(_selected_units[3]);
		
	if _hover_sprite.visible:
		var vec = get_viewport().get_mouse_position() - self.position # getting the vector from self to the mouse
		_cursor.position = vec 
		
		var areas = _cursor.get_overlapping_areas()
		assert(areas.size() <= 1)
		
		if (areas.size() != 1):
			_hover_sprite.position = vec
			return
			
		var area = areas[0]
		
		if not area.get_parent().ally_zone_is_available(): 
			_hover_sprite.position = vec
			return
			
		_hover_sprite.position = area.global_position
		
		if Input.is_action_just_pressed("left_mouse"):
			_hover_sprite.visible = false
			_lanes.hide()
			_spawn_unit(_hover_sprite.name, area.global_position)

		

func add_unit(unit: UnitTypes.UNIT_TYPE):
	add_child(unit)
	
func _spawn_unit(unit_name: String, unit_position: Vector2):
	var new_unit : UnitTypes.UNIT_TYPE = UnitTypes.name_to_unit_dict[unit_name].instance()
	if Global.GameManager.get_current_money()  >= new_unit.cost:
		Global.GameManager.change_money_by(-new_unit.cost)
		new_unit.make_unit_ally()
		new_unit.global_position = unit_position
		add_child(new_unit)
	else:
		new_unit.queue_free()
		# TODO flash money red to communicate not enough money
	
func _hover_with_unit(unit_name: String):
	_hover_sprite.visible = false
	_hover_sprite = get_node("UnitSprites/" + unit_name)
	_hover_sprite.visible = true
	_lanes.show()

