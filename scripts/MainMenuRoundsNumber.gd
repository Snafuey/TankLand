extends HBoxContainer

onready var roundsLabel: Label = $RoundsLabel
onready var sfxPlayer: AudioStreamPlayer = $SFX

var round_number: int setget update_round_number

func _ready() -> void:
	round_number = Utils.get_total_rounds()
	set_label_text()

func update_round_number(value: int) -> void:
	round_number = value
	if round_number > 10 or round_number < 1:
		play_decline_sound()
	else:
		play_pressed_sound()
	round_number = clamp(round_number, 1, 10) # warning-ignore:narrowing_conversion
	set_label_text()
	Utils.set_total_rounds(round_number)

func set_label_text() -> void:
	roundsLabel.text = "Rounds:" + str(round_number)
	
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

func _on_RoundSelectUp_pressed() -> void:
	self.round_number += 1

func _on_RoundSelectDown_pressed() -> void:
	self.round_number -= 1

func _on_RoundSelectUp_mouse_entered() -> void:
	play_hover_sound()

func _on_RoundSelectDown_mouse_entered() -> void:
	play_hover_sound()
