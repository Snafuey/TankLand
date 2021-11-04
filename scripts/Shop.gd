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
var player_inventory: Inventory
var selected_item: Item
var selected_item_type: String

func _ready() -> void:
	var err: int = Events.connect("shop_item_selected", self, "item_selected")
	if err:
		printerr("Connection Failed " + str(err))
	player_list = Utils.get_tank_data_player_keys()
	set_new_player()


func set_new_player() -> void:
	if player_list.empty():
		#change to be error handing maybe go back to main menu
		typeButtonWeapon.pressed = true
		return
	player_inventory = Utils.get_player_inventory(player_list[0])
	set_header_text(player_list[0])
	typeButtonWeapon.pressed = true


func item_selected(item: Item) -> void:
	selected_item = item
	if GameData.tank_data[player_list[0]]["Money"] >= selected_item.cost:
		enable_buy_button()
	set_inspector()


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
	else:
		roundsRemaining.text = str(GameData.game_settings["Rounds"]) + " Rounds Remain."


func set_inspector() -> void:
	inspectorItemIcon.texture = selected_item.icon
	inspectorItemName.text = selected_item.name
	inspectorItemDetails.text = selected_item.details


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
	var item_slots: Array = itemsContainer.get_children()
	for slot in item_slots:
		slot.change_item_type(type, player_inventory)
	clear_inspector()
	disable_buy_button()


func _on_Weapon_toggled(button_pressed: bool) -> void:
	if button_pressed:
		selected_item_type = "Weapon"
		new_item_type(selected_item_type)

func _on_Defensive_toggled(button_pressed: bool) -> void:
	if button_pressed:
		selected_item_type = "Defensive"
		new_item_type(selected_item_type)

func _on_Purchase_Button_pressed() -> void:
	match selected_item_type:
		"Weapon":
			player_inventory.weapons[selected_item.name]["Amount"] += selected_item.purchase_stack
			GameData.tank_data[player_list[0]]["Money"] -= selected_item.cost
			var item_slots: Array = itemsContainer.get_children()
			for slot in item_slots:
				slot.update_item_qty(selected_item_type, player_inventory)
		"Defensive":
			pass

func _on_DoneButton_pressed() -> void:
	player_list.pop_front()
	if player_list.size() > 0:
		self.visible = false
		yield(get_tree().create_timer(0.25), "timeout")
		self.visible = true
		set_new_player()
	else:
		Events.emit_signal("change_game_state", GameData.GAME_STATES.BATTLE)



