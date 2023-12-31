extends Node

const UNIT_TYPE = preload("res://src/objects/units/Unit.gd")

const MELEE_UNIT = preload("res://src/objects/units/melee_units/BasicMeleeUnit.tscn")
const TANKY_UNIT = preload("res://src/objects/units/melee_units/TankySoldier.tscn")
const HEAVY_UNIT = preload("res://src/objects/units/melee_units/HeavyHitter.tscn")
const FAST_UNIT = preload("res://src/objects/units/melee_units/FastBoi.tscn")
const SEDUCE_UNIT = preload("res://src/objects/units/melee_units/SeduceUnit.tscn")
const STRONGEST_UNIT = preload("res://src/objects/units/melee_units/EverythingBagel.tscn")

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
	"EVERYTHING_BAGEL": STRONGEST_UNIT,
}

var name_to_in_game_name = {
	"PLAIN_BAGEL": "Plain Bagel",
	"NEW_YORK_BAGEL": "New York Bagel",
	"POPPY_SEED_BAGEL": "Poppy Seed Bagel",
	"CYMBAGEL": "Cymbagel",
	"BAGELATINE": "Bagelatine",
	"GRENADEL": "Grenadel",
	"BAEGEL": "Baegel",
	"TREBUCHAGEL": "Trebuchagel",
	"EVERYTHING_BAGEL": "Everything Bagel",
	"JEBAGEL": "Jebageled"
}

var units_unlocked = {
	"PLAIN_BAGEL": true,
	"NEW_YORK_BAGEL": true,
	"POPPY_SEED_BAGEL": true,
	"CYMBAGEL": true,
	"BAGELATINE": true,
	"GRENADEL": true,
	"BAEGEL": true,
	"TREBUCHAGEL": true,
	"BLANK": true,
	"EVERYTHING_BAGEL": true,
	"JEBAGEL": true
}

var selected_units: Array = ["PLAIN_BAGEL", "POPPY_SEED_BAGEL", "BAEGEL", "EVERYTHING_BAGEL"]
