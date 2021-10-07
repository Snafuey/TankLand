extends Node2D

const MAIN_MENU_MUSIC: AudioStream = preload("res://assets/audio/main-menu-music.wav")

onready var currentScene: Node = $CurrentScene
onready var animPlayer: AnimationPlayer = $ScreenTransitionLayer/AnimationPlayer
onready var gameMusic: AudioStreamPlayer = $GameMusic
onready var volumeTween: Tween = $GameMusic/VolumeTween
onready var SFXPlayer1: AudioStreamPlayer = $SFX1
onready var SFXPlayer2: AudioStreamPlayer = $SFX2

var next_scene: String = ""
var next_audio: AudioStream = null
var mute_db: float = -60
var max_db: float = 0
var db_trans_time: float = 5
var avl_SFX_players: Array = []
var SFX_queue: Array = []

func _ready() -> void:
	music_transition(MAIN_MENU_MUSIC, max_db, db_trans_time)
	$ScreenTransitionLayer/Sprite.visible = false


func transition_scene(new_scene: String) -> void:
	animPlayer.play("fade_to_black")
	next_scene = new_scene

func _on_transition_animation_finished(anim_name: String) -> void:
	if anim_name == "fade_to_black":
		currentScene.get_child(0).queue_free()
		currentScene.add_child(load(next_scene).instance())
		animPlayer.play("fade_to_normal")


func music_transition(new_audio: AudioStream, target_db: float, time: float) -> void:
	volumeTween.stop_all() # warning-ignore:return_value_discarded
	max_db = target_db
	db_trans_time = time
	if next_audio == null:
		next_audio = new_audio
		gameMusic.set_stream(next_audio)
		gameMusic.play()
		fade_music_in()
		return
	next_audio = new_audio
	fade_music_out()

func fade_music_in() -> void:
	# warning-ignore:return_value_discarded
	volumeTween.interpolate_property(gameMusic, "volume_db", gameMusic.volume_db, 
																	max_db, db_trans_time, Tween.TRANS_CUBIC, Tween.EASE_OUT)  
	volumeTween.start() # warning-ignore:return_value_discarded

func fade_music_out() -> void:
	 # warning-ignore:return_value_discarded
	volumeTween.interpolate_property(gameMusic, "volume_db", gameMusic.volume_db,
																	mute_db, db_trans_time, Tween.TRANS_CUBIC, Tween.EASE_IN)
	volumeTween.start() # warning-ignore:return_value_discarded

func _on_VolumeTween_tween_completed(_object: Object, _key: NodePath) -> void:
	var music_db: float = gameMusic.get_volume_db()
	if music_db <= -60.0:
		gameMusic.set_stream(next_audio)
		if next_audio == null: return
		gameMusic.play()
		fade_music_in()


func _process(_delta: float) -> void:
	if not SFX_queue.empty():
		if not SFXPlayer1.is_playing():
			SFXPlayer1.set_stream(load(SFX_queue[0]))
			SFX_queue.pop_front()
			SFXPlayer1.play()
		elif not SFXPlayer2.is_playing():
			SFXPlayer2.set_stream(load(SFX_queue[0]))
			SFX_queue.pop_front()
			SFXPlayer2.play()

func play_SFX(sound: String) -> void:
	SFX_queue.append(sound)
