extends Node

var active_tank: KinematicBody2D
var damage_queue: Dictionary

func _ready() -> void:
	pass


func append_damage_queue(tank: KinematicBody2D, damage: int) -> void:
	var keys = damage_queue.keys()
	damage_queue[keys.size()] = [tank, damage]


func apply_tank_damage(damage_data: Array) -> void:
	var tank: KinematicBody2D = damage_data[0]
	print(damage_data[1])
	if tank.current_health > 0:
		tank.current_health -= damage_data[1]
	var keys: Array = damage_queue.keys()
	damage_queue.erase(keys[0]) # warning-ignore:return_value_discarded
	set_next_turn()
		
		
func start_round() -> void:
	active_tank = get_child(0)
	active_tank.is_active = true	
	
func spawn_tanks(terrain_points: Array) -> void:
	var players_to_spawn: Array = GameData.tank_data.keys()
	var scaler: int = Utils.get_tank_num_scaler(terrain_points.size())
	var last_index: int
	var spawn_index: int
	for i in GameData.game_settings["NumOfTanks"]:
		if i == 0:
			# warning-ignore:narrowing_conversion
			var index: int = round(scaler / 2) # warning-ignore:integer_division
			last_index = index
			spawn_index = Utils.get_random_spawn_index(index)
		else:
			var index: int = (last_index + scaler)
			last_index = index
			spawn_index = Utils.get_random_spawn_index(index)
		
		players_to_spawn.shuffle()
		var tank = load(Utils.get_tank_scene_path(players_to_spawn[0])).instance()
		tank.set_script(load(Utils.get_tank_script_path(players_to_spawn[0])))
		tank.init_spawn_data(players_to_spawn[0], terrain_points[spawn_index])
		self.add_child(tank)
		players_to_spawn.pop_front()
	
	Events.emit_signal("turnQueue_tank_spawn_finished")


func set_tank_order(turn_order: Array) -> void:
	for i in GameData.game_settings["NumOfTanks"]:
		var tank: KinematicBody2D = get_node(Utils.get_tank_name_from_slot(turn_order[i]))
		move_child(tank, 0)
	start_round()
		
func set_next_turn() -> void:
	if damage_queue.keys().size() > 0:
		var keys: Array = damage_queue.keys()
		apply_tank_damage(damage_queue[keys[0]])
		return
	yield(get_tree().create_timer(1), "timeout")
	var has_winner: bool = check_for_winner()
	if has_winner:
		end_round()
		return
	active_tank.is_active = false
	var child_count: int = get_child_count()
	var new_tank: int = (active_tank.get_index() + 1) % child_count
	active_tank = get_child(new_tank)
	active_tank.is_active = true
	

func check_for_winner() -> bool:
	var has_winner: bool
	var child_count: int = get_child_count()
	if child_count <= 1:
		has_winner = true
	else:
		has_winner = false
	return has_winner

func end_round() -> void:
	var last_tank: KinematicBody2D = get_child(0)
	if last_tank != null:
		Events.emit_signal("turnQueue_round_finished", last_tank)
	else:
		Events.emit_signal("turnQueue_round_finished", null)

func get_active_tank_name() -> String:
	return active_tank.name
