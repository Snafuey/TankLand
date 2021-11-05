extends Node

static func get_player_slot(tank_name: String) -> String:
	var tank_slot: Array = tank_name.split("-")
	return tank_slot[0]

static func build_tank_node_name(player_slot: String) -> String:
	var tank_node_name: String = player_slot + "-" + GameData.tank_data[player_slot]["Name"]
	return tank_node_name

static func get_player_name(player_slot: String) -> String:
	var player_name: String = GameData.tank_data[player_slot]["Name"]
	return player_name

static func get_player_color(player_slot: String) -> Color:
	var color: Color = GameData.tank_data[player_slot]["Color"]
	return color

static func get_tank_data_keys() -> Array:
	var player_list: Array = GameData.tank_data.keys()
	return player_list

static func get_player_inventory(player_slot: String) -> Inventory:
	var player_inventory: Inventory = GameData.all_inventories[player_slot]
	return player_inventory

static func get_spawn_index_scaler(num: int) -> int:
	var scaler: int = round(num / GameData.game_settings["NumOfTanks"]) # warning-ignore:narrowing_conversion
	return scaler

static func get_random_spawn_index(index: int) -> int:
	randomize()
	var new_index: int = round(index + rand_range(-9 , 9)) # warning-ignore:narrowing_conversion
	return new_index

static func get_random_index_range(start: int, end: int) -> int:
	randomize()
	var new_index: int = round(rand_range(start, end)) # warning-ignore:narrowing_conversion
	return new_index

static func get_tank_data_by_type(type: String) -> Array:
	var ranks: Array = []
	var player_list: Array = Utils.get_tank_data_keys()
	for player in player_list:
		var value: int = GameData.tank_data[player][type]
		ranks.append([value, player])
	return ranks

static func sort_decending(a, b) -> bool:
	if a[0] > b[0]:
		return true
	return false

static func get_tank_script_path(player_slot: String) -> String:
	var path: String = "res://scripts/" + GameData.tank_data[player_slot]["Controller"] + ".gd"
	return path

static func get_tank_scene_path(player_slot: String) -> String:
	var path: String = "res://scenes/tanks/" + GameData.tank_data[player_slot]["Tank"] + ".tscn"
	return path

static func get_total_tank_number() -> int:
	var tank_number: int = GameData.game_settings["NumOfTanks"]
	return tank_number

static func set_total_tank_number(value: int) -> void:
	GameData.game_settings["NumOfTanks"] = value

static func get_total_rounds() -> int:
	var rounds: int = GameData.game_settings["Rounds"]
	return rounds

static func set_total_rounds(value: int) -> void:
	GameData.game_settings["Rounds"] = value

static func get_tank_color_by_index(index: int) -> Color:
	var color: Color = GameData.tank_colors[index]
	return color

static func get_random_terrian_color() -> Color:
	var color: Color = GameData.terrain_colors[get_random_index_range(0, 
		GameData.terrain_colors.size())]
	return color	

static func get_random_wall_type() -> String:
	var walls_list: Array = GameData.game_settings["Walls"]
	walls_list.erase("Random")
	var random_wall: String = walls_list[Utils.get_random_index_range(0 , walls_list.size())]
	return random_wall
