extends Control

const BATTLEFIELD: String = "res://scenes/level/BattleField.tscn"

onready var background: ColorRect = $Background
onready var title: Label = $CenterContainer/UIPanel/Title
onready var nameInput: LineEdit = $CenterContainer/UIPanel/NameInput
onready var tankIcons: Control = $CenterContainer/UIPanel/TankIcons
onready var doneButtonLabel: Label = $CenterContainer/UIPanel/DoneButonLabel
onready var doneButton: TextureButton = $CenterContainer/UIPanel/DoneButton

var colors: Array = GameData.tank_colors.keys()
var color_index: int = 0
var player_total: int = GameData.game_settings["Players"]
var current_player: int = 1
var selected_tank: String
var controller: String
var player_name: String

func _ready() -> void:
	set_colors()
	set_title_text()
	nameInput.grab_focus()


func _process(_delta: float) -> void:
	if selected_tank != "" and controller != "" and !nameInput.text.empty():
		doneButtonLabel.set("custom_colors/font_color", Color(0, 0, 0))
		doneButtonLabel.set("custom_colors/font_color_shadow", Color(1, 1, 1))
		doneButton.disabled = false
	else:
		doneButtonLabel.set("custom_colors/font_color", Color(0.37, 0.37, 0.37))
		doneButtonLabel.set("custom_colors/font_color_shadow", Color(1, 1, 1))
		doneButton.disabled = true
		

func _on_TankSelect_toggled(tank_num: int) -> void:
	selected_tank = "Tank" + str(tank_num)


func _on_Controller_button_down(type: String) -> void:
	controller = type


func _on_DoneButton_pressed() -> void:
	set_player_data()

		
func set_player_data() -> void:
	GameData.player_data["Player" + str(current_player)] = {
		"Name": nameInput.text,
		"Color": GameData.tank_colors[colors[color_index]],
		"Tank": selected_tank,
		"Controller": controller,
		"Money": GameData.game_settings["StartingMoney"],
		"Earnings": GameData.game_settings["StartingMoney"],
		"Kills": 0,
		"Suicide": 0,
		"TotalKills": 0 }
	if current_player < player_total:
		current_player += 1
		color_index += 1
		next_player_reset()
	else:
		var sceneManager: Node2D = find_parent("GameMain")
		var rng_index: int = GameData.get_random_index_range(0, (GameData.battle_music.size() - 1))
		sceneManager.music_transition(load(GameData.battle_music[rng_index]), -30 , 2)
		sceneManager.transition_scene(BATTLEFIELD)
	

func next_player_reset() -> void:
	var buttons = get_tree().get_nodes_in_group("selectButtons")
	for button in buttons:
		button.pressed = false
	set_colors()
	set_title_text()
	selected_tank = ""
	controller = ""
	nameInput.text = ""
	nameInput.grab_focus()
	

func set_colors() -> void:
	background.color = GameData.tank_colors[colors[color_index]]
	tankIcons.modulate = GameData.tank_colors[colors[color_index]]


func set_title_text() -> void:
	title.text = "Player " + str(current_player) + " (of " + str(player_total) + ")"
	