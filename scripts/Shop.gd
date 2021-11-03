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
var current_player_inventory: Inventory

func _ready() -> void:
	var err: int = Events.connect("shop_item_selected", self, "item_selected")
	if err:
		printerr("Connection Failed " + str(err))
	player_list = ["Player1"]
#	player_list = Utils.get_tank_data_player_keys()
	set_new_player(player_list)


func item_selected(item: Item) -> void:
	enable_buy_button()
	set_inspector(item)


func set_new_player(players: Array) -> void:
	if players.empty():
		#change to be error handing maybe go back to main menu
		typeButtonWeapon.pressed = true
		return
	var current_player: String = players[0]
	current_player_inventory = Utils.get_player_inventory(current_player)
	set_header_text(current_player)
	typeButtonWeapon.pressed = true


func set_header_text(player: String) -> void:
	if GameData.tank_data.empty():
		return
	var color: Color = GameData.tank_data[player]["Color"]
	playerName.text = GameData.tank_data[player]["Name"]
	playerName.set("custom_colors/font_color", color)
	playerCash.text = "$" + str(GameData.tank_data[player]["Money"])
	set_remaining_rounds()


func set_remaining_rounds() -> void:
	var battleMain: Node = get_parent().get_node_or_null("BattleField")
	if battleMain:
		var current_round: int = battleMain.get_current_round()
		var remaining_rounds = GameData.game_settings["Rounds"] - current_round
		if remaining_rounds == 1:
			roundsRemaining.text = str(remaining_rounds) + " Round Remains."
		else:
			roundsRemaining.text = str(remaining_rounds) + " Rounds Remain."


func set_inspector(item: Item) -> void:
	inspectorItemIcon.texture = item.icon
	inspectorItemName.text = item.name
	inspectorItemDetails.text = item.details


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
		item.change_item_type(type, current_player_inventory)
	clear_inspector()
	disable_buy_button()


func _on_Weapon_toggled(button_pressed: bool) -> void:
	if button_pressed:
		new_item_type("Weapon")


func _on_Defensive_toggled(button_pressed: bool) -> void:
	if button_pressed:
		new_item_type("Defensive")


func _on_DoneButton_pressed() -> void:
	player_list.pop_front()
	if player_list.size() > 0:
		set_new_player(player_list)
	else:
		print("Load New Scene")
