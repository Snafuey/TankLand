extends "res://scripts/Tank.gd"

var target: KinematicBody2D

func test_calculate_power(target: Vector2, start:Vector2, angle_rad: float) -> void:
	var cos_angle: float = abs(cos(angle_rad))
	var squared_cos_angle: float = pow(cos_angle, 2)
	var x_distance: float = abs(start.x - target.x)
	var squared_x_dist: float = pow(x_distance, 2)
	var y_diff: float = target.y - start.y
	var y_x_diff: float = y_diff - x_distance
	var x_dist_over_sq_cos: float = squared_x_dist / squared_cos_angle
	var squared_power: float = (abs((91*x_dist_over_sq_cos) / y_x_diff))
	var final_power: float = sqrt(squared_power)
	
func _physics_process(delta: float) -> void:
	"""
	if active 
	set a target
	calculate a trajectory to hit the target
	use the points of the trajectory get direct space state and raycast to check for terrain obstacles
	if you hit something return the point and adjust using that info
	keep in mind it its on the way up or the way down
	"""
func set_target() -> void:
	"""
	get the turnQueue childern
	use a match case for differnt AI types
	pick and set a target
	"""
func get_target_position() -> Vector2:
	var pos: Vector2 = target.global_position
	return pos


