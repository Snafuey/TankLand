extends CanvasLayer

onready var power: Label = $Hud/MarginContainer/VBox/Row1/Power
onready var angle: Label = $Hud/MarginContainer/VBox/Row1/Angle
onready var tankName: Label = $Hud/MarginContainer/VBox/Row1/Name
onready var weaponIcon: TextureRect = $Hud/MarginContainer/VBox/Row1/WeaponIcon
onready var weaponLabel: Label = $Hud/MarginContainer/VBox/Row1/WeaponLabel
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
	err = Events.connect("tank_weapon_changed", self, "change_weapon")
	if err:
		printerr("Connection Failed " + str(err))


func new_tank_active(_power: int, _angle: float, _health: int, player_slot: String) -> void:
	change_power(_power)
	change_angle(_angle)
	change_health(_health)
	change_name(player_slot)
	change_weapon(player_slot)

func change_power(value: int) -> void:
	power.text = str(value)

func change_angle(value: float) -> void:
	angle.text = str(value).trim_prefix("-")

func change_health(value: int) -> void:
	health.text = str(value)

func change_name(player_slot: String) -> void:
	var player_name: String = Utils.get_player_name_from_slot(player_slot)
	var color: Color = GameData.tank_data[player_slot]["Color"]
	tankName.text = player_name
	tankName.set("custom_colors/font_color", color)

func change_weapon(player_slot: String) -> void:
	var inventory: Inventory = Utils.get_player_inventory(player_slot)
	var equipped_item: Item = inventory.get_equipped_weapon()
	weaponIcon.texture = equipped_item.icon
	var equipped_item_qty: int = inventory.weapons[equipped_item.name]["Amount"]
	var weapon_text: String = ": " + str(equipped_item_qty) + " - " + equipped_item.name
	weaponLabel.text = weapon_text 
