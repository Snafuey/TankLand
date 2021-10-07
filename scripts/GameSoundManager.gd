extends Node

onready var gameMusicPlayer: AudioStreamPlayer = $GameMusic
onready var SFXPlayer1: AudioStreamPlayer = $SFX1
onready var SFXPlayer2: AudioStreamPlayer = $SFX2
onready var volumeTween: Tween = $VolumeTween

var paused_position: float

func change_music(new_audio: AudioStream, vol_db: float = 0, fade_time: float = 1) -> void:
	volumeTween.stop(gameMusicPlayer, "volume_db") # warning-ignore:return_value_discarded
	var has_stream: AudioStream = gameMusicPlayer.get_stream()
	if has_stream:
		fade_music(-60, fade_time)
		yield(volumeTween, "tween_completed")
	gameMusicPlayer.set_stream(new_audio)
	gameMusicPlayer.play()
	fade_music(vol_db, fade_time)

func fade_music(final_db: float, time: float) -> void:
	# warning-ignore:return_value_discarded
	volumeTween.interpolate_property(gameMusicPlayer, "volume_db", gameMusicPlayer.volume_db, 
																	final_db, time, Tween.TRANS_CUBIC, Tween.EASE_OUT)  
	volumeTween.start() # warning-ignore:return_value_discarded

func pause_music() -> void:
	paused_position = gameMusicPlayer.get_playback_position()
	gameMusicPlayer.stop()

func unpause_music() -> void:
	gameMusicPlayer.play(paused_position)

func play_SFX(new_SFX: AudioStream) -> void:
	var current_stream = SFXPlayer1.get_stream()
	if current_stream != new_SFX:
		SFXPlayer1.set_stream(new_SFX)
	SFXPlayer1.play()
	
	
	
	
	
