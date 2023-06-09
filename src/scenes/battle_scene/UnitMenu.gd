extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(UnitTypes.selected_units.size()):
		var sprite = get_node(UnitTypes.selected_units[i])
		var point: Node2D = get_node("P" + str(i))
		point.visible = true
		sprite.visible = true
		sprite.global_position = point.global_position
		
		var new_unit : UnitTypes.UNIT_TYPE = UnitTypes.name_to_unit_dict[UnitTypes.selected_units[i]].instance()
		var unit_cost = new_unit.cost
		new_unit.queue_free()
		point.get_node("Info").text = "              "+ str(unit_cost) + "\n\n" + str(i+1) 
		
