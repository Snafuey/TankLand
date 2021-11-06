extends "res://scripts/Tank.gd"

func _process(_delta: float) -> void:
	if allow_inputs:
		if Input.is_action_pressed("fine_control"):
			if Input.is_action_just_pressed("angle_left"):
				self.angle -= 0.5
			if Input.is_action_just_pressed("angle_right"):
				self.angle += 0.5
			if Input.is_action_just_pressed("power+"):
				self.power += 1
			if Input.is_action_just_pressed("power-"):
				self.power -= 1
		else:
			if Input.is_action_pressed("angle_left"):
				self.angle -= 0.5
			if Input.is_action_pressed("angle_right"):
				self.angle += 0.5
			if Input.is_action_pressed("power+"):
				self.power += 1
			if Input.is_action_pressed("power-"):
				self.power -= 1
		
		if Input.is_action_just_pressed("shoot"):
			allow_inputs = false
			allow_menu = false
			shoot()
	if is_active and allow_menu:
		if Input.is_action_just_pressed("inventory"):
			allow_inputs = false
			Events.emit_signal("inventory_toggled", Utils.get_player_slot(self.name))
