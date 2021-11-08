extends Control

onready var playersLabel: Label = $HBox/ButtonContainerRect/MarginContainer/VBox/PlayersHBox/PlayersLabel
onready var roundsLabel: Label = $HBox/ButtonContainerRect/MarginContainer/VBox/RoundsHBox/RoundsLabel

var num_of_tanks: int
var rounds: int

func _ready() -> void:
	num_of_tanks = Utils.get_total_tank_number()
	rounds = Utils.get_total_rounds()
	set_values()


func set_values() -> void:
	playersLabel.text = "Players:" + str(num_of_tanks)
	Utils.set_total_tank_number(num_of_tanks)
	
	roundsLabel.text = "Rounds:" + str(rounds)
	Utils.set_total_rounds(rounds)


func _on_StartButton_pressed() -> void:
	Events.emit_signal("change_game_state", GameData.GAME_STATES.TANK_CREATION)


func _on_PlayersUpButton_button_down() -> void:
	num_of_tanks += 1
	num_of_tanks = clamp(num_of_tanks, 2, 7) # warning-ignore:narrowing_conversion
	set_values()
	
func _on_PlayersDownButton_button_down() -> void:
	num_of_tanks -= 1
	num_of_tanks = clamp(num_of_tanks, 2, 7) # warning-ignore:narrowing_conversion
	set_values()


func _on_RoundsUpButton_button_down() -> void:
	rounds += 1
	rounds = clamp(rounds, 1, 10) # warning-ignore:narrowing_conversion
	set_values()


func _on_RoundsDownButton_button_down() -> void:
	rounds -= 1
	rounds = clamp(rounds, 1, 10) # warning-ignore:narrowing_conversion
	set_values()
