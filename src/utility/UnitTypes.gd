extends Node

const UNIT_TYPE = preload("res://src/objects/units/Unit.gd")

const MELEE_UNIT = preload("res://src/objects/units/melee_units/BasicMeleeUnit.tscn")
const TANKY_UNIT = preload("res://src/objects/units/melee_units/TankySoldier.tscn")
const HEAVY_UNIT = preload("res://src/objects/units/melee_units/HeavyHitter.tscn")
const FAST_UNIT = preload("res://src/objects/units/melee_units/FastBoi.tscn")
const SEDUCE_UNIT = preload("res://src/objects/units/melee_units/SeduceUnit.tscn")

const BASIC_RANGED_UNIT = preload("res://src/objects/units/ranged_units/BasicRangedUnit.tscn")
const HEAVY_RANGED_UNIT = preload("res://src/objects/units/ranged_units/HeavyRangedUnit.tscn")

var selected_units: Array = [MELEE_UNIT, TANKY_UNIT, BASIC_RANGED_UNIT]
