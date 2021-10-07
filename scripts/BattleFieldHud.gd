extends CanvasLayer

onready var backGround = $Hud/Background
onready var power = $Hud/MarginContainer/VBox/Row1/Power
onready var angle = $Hud/MarginContainer/VBox/Row1/Angle
onready var tankName = $Hud/MarginContainer/VBox/Row1/Name
onready var maxPower = $Hud/MarginContainer/VBox/Row2/Max
onready var health = $Hud/MarginContainer/VBox/Row2/Health

func _ready() -> void:
	pass

func new_turn(p_value: int, a_value: float, h_value: int, tank_name: String) -> void:
	change_power(p_value)
	change_angle(a_value)
	change_health(h_value)
	change_name(tank_name)

func change_power(value: int) -> void:
	power.text = str(value)

func change_angle(value: float) -> void:
	var angle_string = str(value)
	angle.text = angle_string.trim_prefix("-")

func change_health(value: int) -> void:
	health.text = str(value)

func change_name(value: String) -> void:
	var player_slot = GameData.get_player_slot(value)
	var player_name = GameData.player_data[player_slot]["Name"]
	var color = GameData.player_data[player_slot]["Color"]
	tankName.text = player_name
	tankName.set("custom_colors/font_color", color)
