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

func set_equipped_weapon(new_weapon: Item) -> void:
	equipped_weapon = new_weapon
	print(self.resource_name)
	Events.emit_signal("tank_weapon_changed", equipped_weapon)

func get_equipped_weapon() -> Item:
	return equipped_weapon

func get_weapon_amount(key: String) -> int:
	var amount: int = weapons[key]["Amount"]
	return amount

func use_weapon_ammo(key: String, amount: int) -> void:
	weapons[key]["Amount"] -= amount

func get_defense_item_amount(key: String) -> int:
	var amount: int = defensive[key]["Amount"]
	return amount
