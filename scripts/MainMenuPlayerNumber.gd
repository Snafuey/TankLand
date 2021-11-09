extends HBoxContainer

onready var playersLabel: Label = $PlayersLabel
onready var sfxPlayer: AudioStreamPlayer = $SFX

var player_number: int setget update_player_number

func _ready() -> void:
	player_number = Utils.get_total_tank_number()

func update_player_number(value: int) -> void:
	player_number = value
	if player_number > 7 or player_number < 2:
		play_decline_sound()
	else:
		play_pressed_sound()
	player_number = clamp(player_number, 2, 7) # warning-ignore:narrowing_conversion
	set_label_text()
	Utils.set_total_tank_number(player_number)

func set_label_text() -> void:
	playersLabel.text = "Players:" + str(player_number)

func play_hover_sound() -> void:
	sfxPlayer.stream = GameData.button_hover_list[Utils.get_rng_index(
		GameData.button_hover_list.size())]
	sfxPlayer.play()

func play_pressed_sound() -> void:
	sfxPlayer.stream = GameData.PRESSED_SFX
	sfxPlayer.play()

func play_decline_sound() -> void:
	sfxPlayer.stream = GameData.DECLINE_SFX
	sfxPlayer.play()

func _on_PlayerSelectUp_pressed() -> void:
	self.player_number += 1
	
func _on_PlayerSelectDown_pressed() -> void:
	self.player_number -= 1

func _on_PlayerSelectUp_mouse_entered() -> void:
	play_hover_sound()

func _on_PlayerSelectDown_mouse_entered() -> void:
	play_hover_sound()
