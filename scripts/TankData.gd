extends Reference
class_name TankData

var name: String 
var health: int
var power: int
var angle: float

func _init(_name: String, _health: int, _power: int, _angle: float) -> void:
	name = _name
	health = _health
	power = _power
	angle = _angle
