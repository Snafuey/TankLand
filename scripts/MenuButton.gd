extends NinePatchRect

const NORMAL_TEXTURE = preload("res://assets/sprites/Menu Button Normal.png")
const HOVER_TEXTURE = preload("res://assets/sprites/Menu Button Hover.png")
const PRESSED_TEXTURE = preload("res://assets/sprites/Menu Button Pressed.png")


func _on_Button_down() -> void:
	self.texture = PRESSED_TEXTURE


func _on_Button_mouse_entered() -> void:
	self.texture = HOVER_TEXTURE


func _on_Button_mouse_exited() -> void:
	self.texture = NORMAL_TEXTURE


func _on_Button_up() -> void:
	self.texture = NORMAL_TEXTURE
