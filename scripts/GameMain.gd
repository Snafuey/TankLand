extends Node

onready var currentScene: SceneManager = $CurrentScene
onready var animPlayer: AnimationPlayer = $ScreenTransitionLayer/AnimationPlayer
onready var soundManager: SoundManager = $GameSoundManager

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
	if previous_state == GameData.GAME_STATES.PAUSE:
		get_tree().paused = false
		return
	
	match state:
		GameData.GAME_STATES.MAIN_MENU:
			soundManager.change_music(GameData.MAIN_MENU_MUSIC, 0, 5)
			if currentScene.get_child_count() == 0:
				currentScene.add_child_path("res://scenes/menus/MainMenu.tscn")
			else:
				animPlayer.play("fade_to_black")
				yield(animPlayer, "animation_finished")
				currentScene.queue_child_index(0)
				currentScene.add_child_path("res://scenes/menus/MainMenu.tscn")
				animPlayer.play("fade_to_normal")
		
		GameData.GAME_STATES.TANK_CREATION:
			soundManager.change_music(GameData.TANK_CREATION_MUSIC, 0, 1)
			animPlayer.play("fade_to_black")
			yield(animPlayer, "animation_finished")
			currentScene.queue_child_index(0)
			currentScene.add_child_path("res://scenes/menus/TankCreationMenu.tscn")
			animPlayer.play("fade_to_normal")
		
		GameData.GAME_STATES.SHOP:
			soundManager.change_music(GameData.SHOP_MUSIC, 0, 3)
			if previous_state == GameData.GAME_STATES.TANK_CREATION:
				animPlayer.play("fade_to_black")
				yield(animPlayer, "animation_finished")
				currentScene.queue_child_index(0)
			currentScene.add_child_path("res://scenes/menus/Shop.tscn")
			animPlayer.play("fade_to_normal")
		
		GameData.GAME_STATES.BATTLE:
			soundManager.change_music(GameData.battle_music_list[Utils.get_rng_index(
				GameData.battle_music_list.size())], 0, 2)
			match previous_state:
				GameData.GAME_STATES.ROUND_RANKING: 
					Utils.set_new_round_data()
					var battleMain: Node = currentScene.get_child(0)
					battleMain.current_round += 1
					battleMain.init_new_battle()
					return
				GameData.GAME_STATES.FINAL_SCORE:
					Utils.set_replay_game_data()
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
			soundManager.change_music(GameData.MAIN_MENU_MUSIC, 0, 3)
			currentScene.add_child_path("res://scenes/menus/Rankings.tscn")
		
		GameData.GAME_STATES.PAUSE:
			currentScene.add_child_path("res://scenes/menus/PauseMenu.tscn")
			var pauseMenu: Node = currentScene.get_node("PauseMenu")
			pauseMenu.set_return_state(previous_state)
			get_tree().paused = true

		GameData.GAME_STATES.FINAL_SCORE:
			soundManager.change_music(GameData.MAIN_MENU_MUSIC, 0, 3)
			currentScene.add_child_path("res://scenes/menus/FinalScore.tscn")

func get_game_state() -> int:
	return state

func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_released("pause"):
		get_tree().set_input_as_handled()
		self.state = GameData.GAME_STATES.PAUSE
