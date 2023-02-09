extends Node

const UNIT_TYPE = preload("res://src/objects/units/Unit.gd")

const MELEE_UNIT = preload("res://src/objects/units/melee_units/BasicMeleeUnit.tscn")
const TANKY_UNIT = preload("res://src/objects/units/melee_units/TankySoldier.tscn")
const HEAVY_UNIT = preload("res://src/objects/units/melee_units/HeavyHitter.tscn")
const FAST_UNIT = preload("res://src/objects/units/melee_units/FastBoi.tscn")
const SEDUCE_UNIT = preload("res://src/objects/units/melee_units/SeduceUnit.tscn")

const BASIC_RANGED_UNIT = preload("res://src/objects/units/ranged_units/BasicRangedUnit.tscn")
const HEAVY_RANGED_UNIT = preload("res://src/objects/units/ranged_units/HeavyRangedUnit.tscn")

var name_to_unit_dict = {
	"PLAIN_BAGEL": MELEE_UNIT,
	"NEW_YORK_BAGEL": TANKY_UNIT,
	"POPPY_SEED_BAGEL": BASIC_RANGED_UNIT,
	"CYMBAGEL": HEAVY_UNIT,
	"BAGELATINE": FAST_UNIT,
	"GRENADEL": MELEE_UNIT,
	"BAEGEL": SEDUCE_UNIT,
	"TREBUCHAGEL": HEAVY_RANGED_UNIT,
	"BLANK": MELEE_UNIT,
	"EVERYTHING_BAGEL": MELEE_UNIT,
}

var selected_units: Array = [MELEE_UNIT, FAST_UNIT, BASIC_RANGED_UNIT]
