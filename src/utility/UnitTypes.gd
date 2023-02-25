extends Node

const UNIT_TYPE = preload("res://src/objects/units/Unit.gd")

const MELEE_UNIT = preload("res://src/objects/units/melee_units/BasicMeleeUnit.tscn")
const TANKY_UNIT = preload("res://src/objects/units/melee_units/TankySoldier.tscn")
const HEAVY_UNIT = preload("res://src/objects/units/melee_units/HeavyHitter.tscn")
const FAST_UNIT = preload("res://src/objects/units/melee_units/FastBoi.tscn")
const SEDUCE_UNIT = preload("res://src/objects/units/melee_units/SeduceUnit.tscn")

const BASIC_RANGED_UNIT = preload("res://src/objects/units/ranged_units/BasicRangedUnit.tscn")
const GRENADE_RANGED_UNIT = preload("res://src/objects/units/ranged_units/GrenadeRangedUnit.tscn")
const HEAVY_RANGED_UNIT = preload("res://src/objects/units/ranged_units/HeavyRangedUnit.tscn")

var unit_names = ["PLAIN_BAGEL", "NEW_YORK_BAGEL", "POPPY_SEED_BAGEL", "CYMBAGEL", "BAGELATINE", "GRENADEL", "BAEGEL", "TREBUCHAGEL", "BLANK", "EVERYTHING_BAGEL"]

var name_to_unit_dict = {
	"PLAIN_BAGEL": MELEE_UNIT,
	"NEW_YORK_BAGEL": TANKY_UNIT,
	"POPPY_SEED_BAGEL": BASIC_RANGED_UNIT,
	"CYMBAGEL": HEAVY_UNIT,
	"BAGELATINE": FAST_UNIT,
	"GRENADEL": GRENADE_RANGED_UNIT,
	"BAEGEL": SEDUCE_UNIT,
	"TREBUCHAGEL": HEAVY_RANGED_UNIT,
	"EVERYTHING_BAGEL": MELEE_UNIT,
}

var units_unlocked = {
	"PLAIN_BAGEL": true,
	"NEW_YORK_BAGEL": true,
	"POPPY_SEED_BAGEL": true,
	"CYMBAGEL": false,
	"BAGELATINE": false,
	"GRENADEL": false,
	"BAEGEL": false,
	"TREBUCHAGEL": false,
	"BLANK": false,
	"EVERYTHING_BAGEL": false,
}

var selected_units: Array = [TANKY_UNIT, GRENADE_RANGED_UNIT, FAST_UNIT]
