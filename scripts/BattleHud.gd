extends CanvasLayer

onready var power: Label = $Hud/MarginContainer/VBox/Row1/Power
onready var angle: Label = $Hud/MarginContainer/VBox/Row1/Angle
onready var tankName: Label = $Hud/MarginContainer/VBox/Row1/Name
onready var weaponIcon: TextureRect = $Hud/MarginContainer/VBox/Row1/WeaponButton/HBox/WeaponIcon
onready var weaponLabel: Label = $Hud/MarginContainer/VBox/Row1/WeaponButton/HBox/WeaponLabel
onready var maxPower: Label = $Hud/MarginContainer/VBox/Row2/Max
onready var health: Label = $Hud/MarginContainer/VBox/Row2/Health

var active_inventory: Inventory
var active_player_slot: String

func _ready() -> void:
	var err: int = Events.connect("new_active_tank", self, "new_tank_active")
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
	active_inventory = Utils.get_player_inventory(player_slot)
	active_player_slot = player_slot
	change_power(_power)
	change_angle(_angle)
	change_health(_health)
	change_name(player_slot)
	change_weapon(active_inventory.equipped_weapon)


func change_power(value: int) -> void:
	power.text = str(value)


func change_angle(value: float) -> void:
	angle.text = str(value).trim_prefix("-")


func change_health(value: int) -> void:
	health.text = str(value)


func change_name(player_slot: String) -> void:
	tankName.text = Utils.get_player_name(player_slot)
	tankName.set("custom_colors/font_color", Utils.get_player_color(player_slot))


func change_weapon(item: Item) -> void:
	if active_inventory:
		weaponIcon.texture = item.icon
		var amount: int = active_inventory.get_weapon_amount(item.name)
		weaponLabel.text = ": " + str(amount) + " - " + item.name


func _on_WeaponButton_pressed() -> void:
	Events.emit_signal("inventory_toggled", active_player_slot)
