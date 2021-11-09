extends Control

const SOUND_SETTINGS = preload("res://scenes/menus/SoundSettings.tscn")


func _on_StartButton_pressed() -> void:
	Events.emit_signal("change_game_state", GameData.GAME_STATES.TANK_CREATION)


func _on_WeaponsButton_pressed() -> void:
	pass # Replace with function body.


func _on_EconButton_pressed() -> void:
	pass # Replace with function body.


func _on_PhysicsButton_pressed() -> void:
	pass # Replace with function body.


func _on_LandscapeButton_pressed() -> void:
	pass # Replace with function body.


func _on_SoundButton_pressed() -> void:
	var sound_settings: Control = SOUND_SETTINGS.instance()
	get_parent().add_child(sound_settings)


func _on_SaveButton_pressed() -> void:
	pass # Replace with function body.
