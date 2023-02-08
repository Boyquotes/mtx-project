extends Node2D

func _init():
	Global.UnitManager = self

func add_unit(unit: UnitTypes.UNIT_TYPE):
	add_child(unit)
	
func remove_unit(unit: UnitTypes.UNIT_TYPE):
	print("destroyign ", unit)
	unit.queue_free()
