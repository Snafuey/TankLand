class_name SoundManager
extends Node

onready var gameMusicPlayer: AudioStreamPlayer = $GameMusicPlayer
onready var SFXPlayer: AudioStreamPlayer = $SFXPlayer
onready var volumeTween: Tween = $VolumeTween

var next_music_stream: AudioStream = null
var target_db: float
var mute_db: float = -60.0
var fade_time: float
var paused_position: float

func change_music(new_audio: AudioStream, vol_db: float, time: float) -> void:
	volumeTween.stop(gameMusicPlayer, "volume_db") # warning-ignore:return_value_discarded
	target_db = vol_db
	fade_time = time
	if next_music_stream == null:
		next_music_stream = new_audio
		gameMusicPlayer.set_stream(next_music_stream)
		gameMusicPlayer.play()
		fade_music_in()
		return
	next_music_stream = new_audio
	fade_music_out()

func fade_music_in() -> void:
	volumeTween.interpolate_property( # warning-ignore:return_value_discarded
			gameMusicPlayer, "volume_db", gameMusicPlayer.volume_db, 
			target_db, fade_time, Tween.TRANS_CUBIC, Tween.EASE_OUT)  
	volumeTween.start() # warning-ignore:return_value_discarded

func fade_music_out() -> void:
	volumeTween.interpolate_property( # warning-ignore:return_value_discarded
			gameMusicPlayer, "volume_db", gameMusicPlayer.volume_db, 
			mute_db, fade_time, Tween.TRANS_CUBIC, Tween.EASE_IN)  
	volumeTween.start() # warning-ignore:return_value_discarded

func _on_VolumeTween_tween_completed(_object: Object, _key: NodePath) -> void:
	var current_db: float = gameMusicPlayer.get_volume_db()
	if current_db <= -60.0:
		gameMusicPlayer.set_stream(next_music_stream)
		if next_music_stream == null: 
			return
		gameMusicPlayer.play()
		fade_music_in()

func pause_music() -> void:
	paused_position = gameMusicPlayer.get_playback_position()
	gameMusicPlayer.stop()

func unpause_music() -> void:
	gameMusicPlayer.play(paused_position)

func play_SFX(new_SFX: AudioStream) -> void:
	var current_stream: AudioStream = SFXPlayer.get_stream()
	if current_stream != new_SFX:
		SFXPlayer.set_stream(new_SFX)
	SFXPlayer.play()
	

