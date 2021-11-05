extends Control

onready var backGround: ColorRect = $Background

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
var player_slot
var player_inventory: Inventory
var selected_item: Item
var selected_item_type: String

func _ready() -> void:
	var err: int = Events.connect("shop_item_selected", self, "item_selected")
	if err:
		printerr("Connection Failed " + str(err))
	player_list = Utils.get_tank_data_keys()
	set_new_player()


func set_new_player() -> void:
	if player_list.empty():
		#change to be error handing maybe go back to main menu
		typeButtonWeapon.pressed = true
		return
	player_slot = player_list[0]
	player_inventory = Utils.get_player_inventory(player_slot)
	set_header_text()
	typeButtonWeapon.pressed = true


func set_header_text() -> void:
	if GameData.tank_data.empty():
		return
	playerName.text = Utils.get_player_name(player_slot)
	playerName.set("custom_colors/font_color", Utils.get_player_color(player_slot))
	backGround.color = Utils.get_player_color(player_slot)
	set_cash_amount()
	set_remaining_rounds()


func set_cash_amount() -> void:
	playerCash.text = "$" + str(GameData.tank_data[player_slot]["Money"])


func set_remaining_rounds() -> void:
	var battleMain: Node = get_parent().get_node_or_null("BattleField")
	if battleMain:
		var current_round: int = battleMain.get_current_round()
		var remaining_rounds: int = GameData.game_settings["Rounds"] - current_round
		if remaining_rounds == 1:
			roundsRemaining.text = str(remaining_rounds) + " Round Remains."
		else:
			roundsRemaining.text = str(remaining_rounds) + " Rounds Remain."
	else:
		roundsRemaining.text = str(GameData.game_settings["Rounds"]) + " Rounds Remain."


func item_selected(item: Item) -> void:
	selected_item = item
	if GameData.tank_data[player_slot]["Money"] >= selected_item.cost:
		enable_buy_button()
	set_inspector()


func set_inspector() -> void:
	inspectorItemIcon.texture = selected_item.icon
	inspectorItemName.text = selected_item.name
	inspectorItemDetails.text = selected_item.details


func clear_inspector() -> void:
	inspectorItemIcon.texture = null
	inspectorItemName.text = ""
	inspectorItemDetails.text = ""


func enable_buy_button() -> void:
	buyButtonLabel.set("custom_colors/font_color", Color(0, 0, 0))
	buyButtonLabel.set("custom_colors/font_color_shadow", Color(1, 1, 1))
	buyButton.disabled = false


func disable_buy_button() -> void:
	buyButtonLabel.set("custom_colors/font_color", Color(0.37, 0.37, 0.37))
	buyButtonLabel.set("custom_colors/font_color_shadow", Color(1, 1, 1))
	buyButton.disabled = true


func update_item_slots() -> void:
	var item_slots: Array = itemsContainer.get_children()
	for slot in item_slots:
		slot.set_item_data(selected_item_type, player_inventory)


func _on_Weapon_toggled(button_pressed: bool) -> void:
	if button_pressed:
		selected_item_type = "Weapon"
		update_item_slots()
		clear_inspector()
		disable_buy_button()


func _on_Defensive_toggled(button_pressed: bool) -> void:
	if button_pressed:
		selected_item_type = "Defensive"
		update_item_slots()
		clear_inspector()
		disable_buy_button()


func _on_Purchase_Button_pressed() -> void:
	match selected_item_type:
		"Weapon":
			player_inventory.weapons[selected_item.name]["Amount"] += selected_item.purchase_stack
			GameData.tank_data[player_slot]["Money"] -= selected_item.cost
			set_cash_amount()
			update_item_slots()
		"Defensive":
			pass
	if selected_item.cost > GameData.tank_data[player_slot]["Money"]:
		disable_buy_button()


func _on_DoneButton_pressed() -> void:
	player_list.pop_front()
	if player_list.size() > 0:
		self.visible = false
		yield(get_tree().create_timer(0.25), "timeout")
		self.visible = true
		set_new_player()
	else:
		Events.emit_signal("change_game_state", GameData.GAME_STATES.BATTLE)
