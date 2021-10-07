extends Control

const TANK_CREATION: String = "res://scenes/menus/TankCreationMenu.tscn"
const TANK_CREATION_MUSIC: AudioStream = preload("res://assets/audio/TrankCreationMenu.wav")

onready var playersLabel = $HBox/ButtonContainerRect/MarginContainer/VBox/PlayersHBox/PlayersLabel
onready var roundsLabel = $HBox/ButtonContainerRect/MarginContainer/VBox/RoundsHBox/RoundsLabel

var players: int
var rounds: int

func _ready() -> void:
	players = GameData.game_settings["Players"]
	rounds = GameData.game_settings["Rounds"]
	set_values()


func set_values() -> void:
	playersLabel.text = "Players:" + str(players)
	GameData.game_settings["Players"] = players
	
	roundsLabel.text = "Rounds:" + str(rounds)
	GameData.game_settings["Rounds"] = rounds


func _on_StartButton_button_down() -> void:
	var sceneManager = find_parent("GameMain")
	sceneManager.music_transition(TANK_CREATION_MUSIC, -30, 1)
	sceneManager.transition_scene(TANK_CREATION)


func _on_PlayersUpButton_button_down() -> void:
	players += 1
	players = clamp(players, 2, 7) # warning-ignore:narrowing_conversion
	set_values()
	

func _on_PlayersDownButton_button_down() -> void:
	players -= 1
	players = clamp(players, 2, 7) # warning-ignore:narrowing_conversion
	set_values()


func _on_RoundsUpButton_button_down() -> void:
	rounds += 1
	rounds = clamp(rounds, 1, 10) # warning-ignore:narrowing_conversion
	set_values()


func _on_RoundsDownButton_button_down() -> void:
	rounds -= 1
	rounds = clamp(rounds, 1, 10) # warning-ignore:narrowing_conversion
	set_values()
