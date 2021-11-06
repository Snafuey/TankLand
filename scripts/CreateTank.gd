extends Control

const BATTLEFIELD: String = "res://scenes/level/BattleField.tscn"

onready var background: ColorRect = $Background
onready var title: Label = $CenterContainer/UIPanel/Title
onready var nameInput: LineEdit = $CenterContainer/UIPanel/NameInput
onready var tankIcons: Control = $CenterContainer/UIPanel/TankIcons
onready var doneButtonLabel: Label = $CenterContainer/UIPanel/DoneButton/Label
onready var doneButton: TextureButton = $CenterContainer/UIPanel/DoneButton/Button

#var colors: Array = GameData.tank_colors.keys()
var color_index: int = 0

var num_of_tanks: int = Utils.get_total_tank_number()
var current_player_number: int = 1
var current_player_slot: String
var selected_tank: String
var controller: String
var player_name: String

func _ready() -> void:
	set_current_player_slot()
	set_colors()
	set_title_text()
	nameInput.grab_focus()


func _process(_delta: float) -> void:
	if selected_tank != "" and controller != "" and !nameInput.text.empty() \
			and nameInput.text != "Name taken":
		doneButtonLabel.set("custom_colors/font_color", Color(0, 0, 0))
		doneButtonLabel.set("custom_colors/font_color_shadow", Color(1, 1, 1))
		doneButton.disabled = false
	else:
		doneButtonLabel.set("custom_colors/font_color", Color(0.37, 0.37, 0.37))
		doneButtonLabel.set("custom_colors/font_color_shadow", Color(1, 1, 1))
		doneButton.disabled = true
		

func set_current_player_slot() -> void:
	current_player_slot = "Player" + str(current_player_number)


func set_colors() -> void:
	background.color = Utils.get_tank_color_by_index(color_index) #GameData.tank_colors[colors[color_index]]
	tankIcons.modulate = Utils.get_tank_color_by_index(color_index) #GameData.tank_colors[colors[color_index]]


func set_title_text() -> void:
	title.text = "Player " + str(current_player_number) + " (of " + str(num_of_tanks) + ")"
	

func _on_TankSelect_toggled(tank_num: int) -> void:
	selected_tank = "Tank" + str(tank_num)


func _on_Controller_button_down(type: String) -> void:
	controller = type


func _on_DoneButton_pressed() -> void:
#	var player_list: Array = Utils.get_tank_data_keys()
	for player in Utils.get_tank_data_keys():
		if nameInput.text == Utils.get_player_name(player):
			nameInput.text = "Name taken"
			return
	set_player_data()


func set_player_data() -> void:
	GameData.tank_data[current_player_slot] = {
		"Name": nameInput.text,
		"Color": Utils.get_tank_color_by_index(color_index), #GameData.tank_colors[colors[color_index]],
		"Tank": selected_tank,
		"Controller": controller,
		"Money": GameData.game_settings["StartingMoney"],
		"Earnings": GameData.game_settings["StartingMoney"],
		"Kills": 0,
		"Suicide": 0,
		"TotalKills": 0 }
	Utils.set_default_inventory(current_player_slot)
	if current_player_number < num_of_tanks:
		next_player_reset()
	else:
		Events.emit_signal("change_game_state", GameData.GAME_STATES.SHOP) #GAME_STATES.BATTLE) 


func next_player_reset() -> void:
	current_player_number += 1
	color_index += 1
	set_current_player_slot()
	clear_menu_inputs()
	set_colors()
	set_title_text()
	nameInput.grab_focus()


func clear_menu_inputs() -> void:
	var buttons = get_tree().get_nodes_in_group("selectButtons")
	for button in buttons:
		button.pressed = false
	selected_tank = ""
	controller = ""
	nameInput.text = ""
