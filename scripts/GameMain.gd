extends Node

#can const all scences and music/sounds that this script sets
const MAIN_MENU_MUSIC: AudioStream = preload("res://assets/audio/main-menu-music.wav")
const TANK_CREATION_MUSIC: AudioStream = preload("res://assets/audio/TrankCreationMenu.wav")

onready var currentScene: Node = $CurrentScene
onready var animPlayer: AnimationPlayer = $ScreenTransitionLayer/AnimationPlayer
onready var soundManager: Node = $GameSoundManager

enum GAME_STATES {
	MAIN_MENU,
	OPTIONS_MENU,
	TANK_CREATION,
	BATTLE,
	PAUSE,
	BATTLE_OVER }

var state: int setget set_game_state, get_game_state
var next_scene_path: String = ""

func _ready() -> void:
	self.state = GAME_STATES.MAIN_MENU
	
func set_game_state(new_state: int) -> void:
	state = new_state
	match state:
		GAME_STATES.MAIN_MENU:
			soundManager.change_music(MAIN_MENU_MUSIC, 0, 5)
			if currentScene.get_child_count() == 0:
				currentScene.add_child_path("res://scenes/menus/MainMenu.tscn")
			else:
				animPlayer.play("fade_to_black")
				yield(animPlayer, "animation_finished")
				currentScene.queue_child_index(0)
				currentScene.add_child_path("res://scenes/menus/MainMenu.tscn")
				animPlayer.play("fade_to_normal")
		GAME_STATES.TANK_CREATION:
			soundManager.change_music(TANK_CREATION_MUSIC, -30, 1)
			animPlayer.play("fade_to_black")
			yield(animPlayer, "animation_finished")
			currentScene.queue_child_index(0)
			currentScene.add_child_path("res://scenes/menus/TankCreationMenu.tscn")
			animPlayer.play("fade_to_normal")
		GAME_STATES.BATTLE:
			pass
		GAME_STATES.PAUSE:
			pass
		GAME_STATES.BATTLE_OVER:
			pass

func get_game_state() -> int:
	var current_state: int = state
	return current_state






