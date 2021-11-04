extends "res://scripts/Tank.gd"


func _process(_delta: float) -> void:
	if can_process_turn:
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
			can_process_turn = false
			shoot()
