extends Node

#can const all scences and music/sounds that this script sets
const MAIN_MENU_MUSIC: = preload("res://assets/audio/MainMenuMusic.ogg")
const TANK_CREATION_MUSIC = preload("res://assets/audio/TrankCreationMenu.wav")

onready var currentScene: Node = $CurrentScene
onready var animPlayer: AnimationPlayer = $ScreenTransitionLayer/AnimationPlayer
onready var soundManager: Node = $GameSoundManager

var state: int setget set_game_state, get_game_state
var next_scene_path: String = ""

func _ready() -> void:
	var err: int = Events.connect("change_game_state", self, "change_state")
	if err:
		printerr("Connection Failed " + str(err))
	self.state = GameData.GAME_STATES.MAIN_MENU

func change_state(new_state: int) -> void:
	self.state = new_state

func set_game_state(new_state: int) -> void:
	var previous_state: int = state
	state = new_state
	match state:
		GameData.GAME_STATES.MAIN_MENU:
			soundManager.change_music(MAIN_MENU_MUSIC, 0, 5)
			if currentScene.get_child_count() == 0:
				currentScene.add_child_path("res://scenes/menus/MainMenu.tscn")
			else:
				animPlayer.play("fade_to_black")
				yield(animPlayer, "animation_finished")
				currentScene.queue_child_index(0)
				currentScene.add_child_path("res://scenes/menus/MainMenu.tscn")
				animPlayer.play("fade_to_normal")
		
		GameData.GAME_STATES.TANK_CREATION:
			soundManager.change_music(TANK_CREATION_MUSIC, -30, 1)
			animPlayer.play("fade_to_black")
			yield(animPlayer, "animation_finished")
			currentScene.queue_child_index(0)
			currentScene.add_child_path("res://scenes/menus/TankCreationMenu.tscn")
			animPlayer.play("fade_to_normal")
		
		GameData.GAME_STATES.BATTLE:
			var rng_music_index: int = Utils.get_random_index_range(
				0, (GameData.battle_music.size() - 1))
			soundManager.change_music(load(GameData.battle_music[rng_music_index]), -30, 2)
			match previous_state:
				GameData.GAME_STATES.ROUND_RANKING: 
					GameData.new_round_set_tank_data()
					var battleMain: Node = currentScene.get_child(0)
					battleMain.current_round += 1
					battleMain.init_new_battle()
					return
				GameData.GAME_STATES.FINAL_SCORE:
					GameData.replay_game_set_tank_data()
					var battleMain: Node = currentScene.get_child(0)
					battleMain.current_round = 1
					battleMain.init_new_battle()
					return
				_:
					continue
			animPlayer.play("fade_to_black")
			yield(animPlayer, "animation_finished")
			currentScene.queue_child_index(0)
			currentScene.add_child_path("res://scenes/level/BattleField.tscn")
			animPlayer.play("fade_to_normal")
		
		GameData.GAME_STATES.ROUND_RANKING:
			soundManager.change_music(MAIN_MENU_MUSIC, 0, 3)
			currentScene.add_child_path("res://scenes/menus/Rankings.tscn")
		
		GameData.GAME_STATES.PAUSE:
			pass
		
		GameData.GAME_STATES.FINAL_SCORE:
			soundManager.change_music(MAIN_MENU_MUSIC, 0, 3)
			currentScene.add_child_path("res://scenes/menus/FinalScore.tscn")

func get_game_state() -> int:
	return state
