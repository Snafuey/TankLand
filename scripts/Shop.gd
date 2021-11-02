extends Control

onready var playerName: Label = $Center/ShopWindow/Header/HeaderHBox/Name
onready var playerCash: Label = $Center/ShopWindow/Header/HeaderHBox/Cash
onready var roundsRemaining: Label = $Center/ShopWindow/Header/HeaderHBox/Rounds

onready var itemsContainer: VBoxContainer = $Center/ShopWindow/ItemsVBox

onready var typeButtonWeapon: CheckBox = $Center/ShopWindow/ItemType/ButtonHBox/Weapon
onready var typeButtonDefensive: CheckBox = $Center/ShopWindow/ItemType/ButtonHBox/Defensive

onready var inspectorItemIcon: TextureRect = $Center/ShopWindow/Inspector/Icon
onready var inspectorItemName: Label = $Center/ShopWindow/Inspector/ItemName
onready var inspectorItemDetails: Label = $Center/ShopWindow/Inspector/InspectorWindow/ItemDetails

onready var buyButton: TextureButton = $Center/ShopWindow/BuyButton/Button
onready var buyButtonLabel: Label = $Center/ShopWindow/BuyButton/Label

var player_list: Array = []

func _ready() -> void:
	var err: int = Events.connect("shop_item_selected", self, "item_selected")
	if err:
		printerr("Connection Failed " + str(err))
	typeButtonWeapon.pressed = true
	player_list = GameData.tank_data.keys()
	set_header_text(player_list)


func item_selected(item_resource: Resource) -> void:
	enable_buy_button()
	set_inspector(item_resource)


func set_header_text(players: Array) -> void:
	if players.empty():
		return	
	var player: String = players[0]
	var color: Color = GameData.tank_data[player]["Color"]
	playerName.text = GameData.tank_data[player]["Name"]
	playerName.set("custom_colors/font_color", color)
	playerCash.text = "$" + str(GameData.tank_data[player]["Money"])
	player_list.pop_front()


func set_inspector(item_resource: Resource) -> void:
	inspectorItemIcon.texture = item_resource.icon
	inspectorItemName.text = item_resource.name
	inspectorItemDetails.text = item_resource.details


func clear_inspector() -> void:
	inspectorItemIcon.texture = null
	inspectorItemName.text = ""
	inspectorItemDetails.text = ""


func disable_buy_button() -> void:
	buyButtonLabel.set("custom_colors/font_color", Color(0.37, 0.37, 0.37))
	buyButtonLabel.set("custom_colors/font_color_shadow", Color(1, 1, 1))
	buyButton.disabled = true


func enable_buy_button() -> void:
	buyButtonLabel.set("custom_colors/font_color", Color(0, 0, 0))
	buyButtonLabel.set("custom_colors/font_color_shadow", Color(1, 1, 1))
	buyButton.disabled = false


func new_item_type(type: String) -> void:
	var items: Array = itemsContainer.get_children()
	for item in items:
		item.change_item_type(type)
	clear_inspector()
	disable_buy_button()


func _on_Weapon_toggled(button_pressed: bool) -> void:
	if button_pressed:
		new_item_type("Weapon")


func _on_Defensive_toggled(button_pressed: bool) -> void:
	if button_pressed:
		new_item_type("Defensive")


func _on_DoneButton_pressed() -> void:
	if player_list.size() > 0:
		typeButtonWeapon.pressed = true
		set_header_text(player_list)
	else:
		print("Load New Scene")
