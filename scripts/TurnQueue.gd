extends Node

var active_tank: KinematicBody2D

func _ready() -> void:
	Events.connect("tank_turn_finished", self, "set_next_turn")

func start_round() -> void:
	active_tank = get_child(0)
	active_tank.is_active = true	
	
func spawn_tanks(terrain_points: Array) -> void:
	var scaler: int = Utils.get_tank_num_scaler(terrain_points.size())
	var last_index: int
	for i in GameData.game_settings["NumOfTanks"]:
		if i == 0:
			var index: int = round(scaler / 2) 
			last_index = index
			var spawn_index: int = Utils.get_random_spawn_index(index)
			tank_spawner(str(i + 1), terrain_points[spawn_index])
		else:
			var index: int = (last_index + scaler)
			last_index = index
			var spawn_index = Utils.get_random_spawn_index(index)
			tank_spawner(str(i + 1), terrain_points[spawn_index])
	Events.emit_signal("turnQueue_tank_spawn_finished")

func tank_spawner(slot_index: String, spawn_pos: Vector2) -> void:
	var tank = load(Utils.get_tank_scene_path(slot_index)).instance()
	tank.set_script(load(Utils.get_tank_script_path(slot_index)))
	tank.init_spawn_data(slot_index, spawn_pos)
	self.add_child(tank)

func set_tank_order(turn_order: Array) -> void:
	for i in GameData.game_settings["NumOfTanks"]:
		var tank: KinematicBody2D = get_node(Utils.get_tank_name_from_slot(turn_order[i]))
		move_child(tank, 0)
	start_round()
		
func set_next_turn() -> void:
	yield(get_tree().create_timer(1), "timeout")
	var has_winner: bool = check_for_winner()
	if has_winner:
		end_round()
		return
	active_tank.is_active = false
	var child_count: int = get_child_count()
	var new_tank: int = (active_tank.get_index() + 1) % child_count
	print(new_tank)
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
	active_tank.is_active = false
	var last_tank: KinematicBody2D = get_child(0)
	if last_tank != null:
		Events.emit_signal("turnQueue_round_finished", last_tank)
	else:
		Events.emit_signal("turnQueue_round_finished", null)

func get_active_tank_name() -> String:
	return active_tank.name


#func make_tank_signal_connections(tank: KinematicBody2D) -> void:
#	if not tank.is_connected("power_changed", battleFieldHud, "change_power"):
#		tank.connect("power_changed", battleFieldHud, "change_power") 
#	if not tank.is_connected("angle_changed", battleFieldHud, "change_angle"):
#		tank.connect("angle_changed", battleFieldHud, "change_angle") 
#	if not tank.is_connected("health_changed", battleFieldHud, "change_health"):
#		tank.connect("health_changed", battleFieldHud, "change_health") 
#	if not tank.is_connected("new_turn_hud_change", battleFieldHud, "new_turn"):
#		tank.connect("new_turn_hud_change", battleFieldHud, "new_turn") 
#	if not tank.is_connected("tank_killed", battleField, "apply_kill"):
#		tank.connect("tank_killed", battleField, "apply_kill")
	
