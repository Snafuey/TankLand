extends Resource
class_name Item

enum TYPE {
	WEAPON,
	DEFENSIVE
} 

export(TYPE) var type = TYPE.WEAPON
export(String) var name = "Name"
export(int) var damage = 0
export(int) var explosion_rad = 0
export(PackedScene) var explosion_scene
export(Texture) var icon
export(int) var cost = 1000
export(int) var purchase_stack = 1
export(int) var maximum_amount = 99
