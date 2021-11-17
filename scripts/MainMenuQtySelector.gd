extends HBoxContainer

enum type {Player, Rounds}

export(type) var type_name

onready var displayLabel: Label = $DisplayLabel
onready var sfxPlayer: AudioStreamPlayer = $SFX

var qty_value: int setget update_qty
var label_string: String

func _ready() -> void:
	match type_name:
		type.Player:
			qty_value = Utils.get_total_tank_number()
			label_string = "Player:"
		type.Rounds:
			qty_value = Utils.get_total_rounds()
			label_string = "Rounds:"
	set_label_text(label_string)
	

func update_qty(value: int) -> void:
	
	qty_value = value
	match type_name:
		type.Player:
			if qty_value > 7 or qty_value < 2:
				play_decline_sound()
			else:
				play_pressed_sound()
			qty_value = clamp(qty_value, 2, 7) # warning-ignore:narrowing_conversion
			Utils.set_total_tank_number(qty_value)
		type.Rounds:
			if qty_value > 10 or qty_value < 1:
				play_decline_sound()
			else:
				play_pressed_sound()
			qty_value = clamp(qty_value, 1, 10) # warning-ignore:narrowing_conversion
			Utils.set_total_rounds(qty_value)
	set_label_text(label_string)
	
func set_label_text(text: String) -> void:
	displayLabel.text = text + str(qty_value)

func play_hover_sound() -> void:
	sfxPlayer.stream = GameData.button_hover_list[Utils.get_rng_index(
		GameData.button_hover_list.size())]
	sfxPlayer.play()

func play_pressed_sound() -> void:
	sfxPlayer.stream = GameData.PRESSED_SFX
	sfxPlayer.play()

func play_decline_sound() -> void:
	sfxPlayer.stream = GameData.CANCEL_SFX
	sfxPlayer.play()

func _on_UpButton_pressed() -> void:
	self.qty_value += 1
	
func _on_DownButton_pressed() -> void:
	self.qty_value -= 1

func _on_UpButton_mouse_entered() -> void:
	play_hover_sound()

func _on_DownButton_mouse_entered() -> void:
	play_hover_sound()
