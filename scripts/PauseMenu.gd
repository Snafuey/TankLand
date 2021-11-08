extends Control

onready var debugButton: Button = $Center/Window/Margin/VBox/DebugButton
onready var radiusPopWindow: AcceptDialog = $Center/PopInputRadius
onready var radiusInput: LineEdit = $Center/PopInputRadius/Margin/RadiusInput

var return_state: int

func set_return_state(state: int) -> void:
	return_state = state


func _ready() -> void:
	set_debug_text()


func _input(event: InputEvent) -> void:
	if event.is_action_released("pause"):
		get_tree().set_input_as_handled()
		Events.emit_signal("change_game_state", return_state)
		self.queue_free()

func set_debug_text() -> void:
	if Utils.DEBUG_MODE:
		debugButton.text = "Debug Mode: On"
		return
	debugButton.text = "Debug Mode:Off"


func _on_DebugButton_pressed() -> void:
	Utils.DEBUG_MODE = !Utils.DEBUG_MODE
	set_debug_text()


func _on_RadiusButton_pressed() -> void:
	radiusPopWindow.popup()
	radiusInput.text = str(Utils.DEBUG_RADIUS_SIZE)


func _on_PopInput_confirmed() -> void:
	var input: String = radiusInput.text
	if input.is_valid_integer() and input.length() <= 3:
		Utils.DEBUG_RADIUS_SIZE = int(input)
	else:
		radiusInput.text = "Not Valid #"
		radiusPopWindow.popup()

