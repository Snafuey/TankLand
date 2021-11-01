extends CanvasLayer

onready var power: Label = $Hud/MarginContainer/VBox/Row1/Power
onready var angle: Label = $Hud/MarginContainer/VBox/Row1/Angle
onready var tankName: Label = $Hud/MarginContainer/VBox/Row1/Name
onready var maxPower: Label = $Hud/MarginContainer/VBox/Row2/Max
onready var health: Label = $Hud/MarginContainer/VBox/Row2/Health

func _ready() -> void:
	var err: int = Events.connect("tank_activated", self, "new_tank_active")
	if err:
		printerr("Connection Failed " + str(err))
	err = Events.connect("tank_angle_changed", self, "change_angle")
	if err:
		printerr("Connection Failed " + str(err))
	err = Events.connect("tank_power_changed", self, "change_power")
	if err:
		printerr("Connection Failed " + str(err))
	err = Events.connect("tank_health_changed", self, "change_health")
	if err:
		printerr("Connection Failed " + str(err))


func new_tank_active(_power: int, _angle: float, _health: int, tank: KinematicBody2D) -> void:
	change_power(_power)
	change_angle(_angle)
	change_health(_health)
	change_name(tank)

func change_power(value: int) -> void:
	power.text = str(value)

func change_angle(value: float) -> void:
	angle.text = str(value).trim_prefix("-")

func change_health(value: int) -> void:
	health.text = str(value)

func change_name(tank: KinematicBody2D) -> void:
	var player_name: String = GameData.tank_data[Utils.get_tank_slot(tank.name)]["Name"]
	var color: Color = GameData.tank_data[Utils.get_tank_slot(tank.name)]["Color"]
	tankName.text = player_name
	tankName.set("custom_colors/font_color", color)
