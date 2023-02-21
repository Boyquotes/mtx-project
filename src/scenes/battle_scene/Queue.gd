extends Label

var _ally_base: StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	_ally_base = get_parent().get_parent().get_node("AllyBase")
	if _ally_base == null:
		print("error: queue text label cant find ally base to read from")
	text = "Units in queue: "
func _on_AllyBase_queue_changed():
	var new_str = "Units in queue: " + str(_ally_base.get_unit_queue().size())
	text = new_str
