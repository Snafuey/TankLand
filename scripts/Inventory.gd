extends Resource
class_name Inventory

export (Dictionary) var weapons = {
	"Baby Missile":{"Item": Item, "Amount": 99},
	"Missile":{"Item": Item, "Amount": 0},
	"Baby Nuke":{"Item": Item, "Amount": 0},
	"Nuke":{"Item": Item, "Amount": 0}
	}

export (Dictionary) var defensive = {}

var equipped_weapon: Item setget set_equipped_weapon, get_equipped_weapon

func set_equipped_weapon(weapon: Item) -> void:
	equipped_weapon = weapon

func get_equipped_weapon() -> Item:
	return equipped_weapon
