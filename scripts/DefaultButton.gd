extends Button

enum type{OK, CANCEL}

export(type) var sound_type

onready var buttonTexture: NinePatchRect = $Texture
onready var sfxPlayer: AudioStreamPlayer = $SFX

func _on_Button_down() -> void:
	buttonTexture.texture = GameData.PRESSED_TEXTURE
	match sound_type:
		type.OK:
			sfxPlayer.stream = GameData.PRESSED_SFX
		type.CANCEL:
			sfxPlayer.stream = GameData.CANCEL_SFX
	sfxPlayer.play()


func _on_Button_mouse_entered() -> void:
	buttonTexture.texture = GameData.HOVER_TEXTURE
	sfxPlayer.stream = GameData.button_hover_list[Utils.get_rng_index(
		GameData.button_hover_list.size())]
	sfxPlayer.play()


func _on_Button_mouse_exited() -> void:
	buttonTexture.texture = GameData.NORMAL_TEXTURE


func _on_Button_up() -> void:
	buttonTexture.texture = GameData.NORMAL_TEXTURE
