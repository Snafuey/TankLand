extends Node
var DEBUG_MODE: bool = false setget set_debug_mode, get_debug_mode
var DEBUG_RADIUS_SIZE: int = 10 setget set_debug_radius, get_debug_radius

func set_debug_mode(value: bool) -> void:
	DEBUG_MODE = value

func get_debug_mode() -> bool:
	return DEBUG_MODE

func set_debug_radius(value: int) -> void:
	DEBUG_RADIUS_SIZE = value

func get_debug_radius() -> int:
	return DEBUG_RADIUS_SIZE

"""
Get Player Data
"""

static func get_player_slot(tank_name: String) -> String:
	var tank_slot: Array = tank_name.split("-")
	return tank_slot[0]

static func get_player_name(player_slot: String) -> String:
	var player_name: String = GameData.tank_data[player_slot]["Name"]
	return player_name

static func get_player_color(player_slot: String) -> Color:
	var color: Color = GameData.tank_data[player_slot]["Color"]
	return color

static func get_player_money(player_slot: String) -> int:
	var money: int = GameData.tank_data[player_slot]["Money"]
	return money

static func get_player_kills(player_slot: String) -> int:
	var kills: int = GameData.tank_data[player_slot]["Kills"]
	return kills

static func get_player_earnings(player_slot: String) -> int:
	var earnings: int = GameData.tank_data[player_slot]["Earnings"]
	return earnings

static func get_player_inventory(player_slot: String) -> Inventory:
	var player_inventory: Inventory = GameData.all_inventories[player_slot]
	return player_inventory

"""
Set Player Data
"""

static func decrease_player_money(player_slot: String, amount: int) -> void:
	GameData.tank_data[player_slot]["Money"] -= amount
	
static func increase_player_money(player_slot: String, amount: int) -> void:
	GameData.tank_data[player_slot]["Money"] -= amount

"""
Get Tank Data
"""

static func get_tank_data_keys() -> Array:
	var player_list: Array = GameData.tank_data.keys()
	return player_list

static func get_tank_script_path(player_slot: String) -> String:
	var path: String = "res://scripts/" + GameData.tank_data[player_slot]["Controller"] + ".gd"
	return path

static func get_tank_scene_path(player_slot: String) -> String:
	var path: String = "res://scenes/tanks/" + GameData.tank_data[player_slot]["Tank"] + ".tscn"
	return path

static func build_tank_node_name(player_slot: String) -> String:
	var tank_node_name: String = player_slot + "-" + GameData.tank_data[player_slot]["Name"]
	return tank_node_name



"""
Get Game Data
"""

static func get_stats_by_type(type: String) -> Array:
	var ranks: Array = []
	var player_list: Array = Utils.get_tank_data_keys()
	for player in player_list:
		var value: int = GameData.tank_data[player][type]
		ranks.append([value, player])
	return ranks

static func get_total_tank_number() -> int:
	var tank_number: int = GameData.game_settings["NumOfTanks"]
	return tank_number

static func get_total_rounds() -> int:
	var rounds: int = GameData.game_settings["Rounds"]
	return rounds

static func get_remaining_rounds(current_round: int) -> int:
	var rounds: int = GameData.game_settings["Rounds"] - current_round
	return rounds

static func get_tank_color_by_index(index: int) -> Color:
	var color: Color = GameData.tank_colors[index]
	return color

static func get_current_walls() -> String:
	return GameData.game_settings["CurrentWalls"]

"""
Set Game Data
"""

static func set_total_rounds(value: int) -> void:
	GameData.game_settings["Rounds"] = value

static func set_total_tank_number(value: int) -> void:
	GameData.game_settings["NumOfTanks"] = value

static func set_new_round_data() -> void:
	var player_list: Array = get_tank_data_keys()
	for player in player_list:
		GameData.tank_data[player]["Suicied"] = 0
		GameData.tank_data[player]["Kills"] = 0

static func set_replay_game_data() -> void:
	var player_list: Array = get_tank_data_keys()
	clear_inventories()
	for player in player_list:
		GameData.tank_data[player]["Money"] = 0
		GameData.tank_data[player]["Earnings"] = 0
		GameData.tank_data[player]["Kills"] = 0
		GameData.tank_data[player]["TotalKills"] = 0
		GameData.tank_data[player]["Suicide"] = 0
		set_default_inventory(player)

static func set_default_inventory(player_slot: String) -> void:
	var player_items: Inventory = load("res://resources/inventories/" + player_slot + ".tres")
	GameData.all_inventories[player_slot] = player_items

static func clear_tank_data() -> void:
	GameData.tank_data = {}

static func clear_inventories() -> void:
	GameData.all_inventories = {}

"""
Get Random Results
"""

static func get_random_terrian_color() -> Color:
	var color: Color = GameData.terrain_colors[get_rng_index(
		GameData.terrain_colors.size())]
	return color

static func get_random_wall_type() -> String:
	var walls_list: Array = GameData.game_settings["Walls"]
	walls_list.erase("Random")
	var random_wall: String = walls_list[get_rng_index(walls_list.size())]
	return random_wall

static func get_random_spawn_index(index: int) -> int:
	randomize()
	var new_index: int = round(index + rand_range(-9 , 9)) # warning-ignore:narrowing_conversion
	return new_index

static func get_rng_index(size: int) -> int:
	randomize()
	var new_index: int = randi() % size
	return new_index

"""
Manipulate Data
"""

static func get_spawn_index_scaler(num: int) -> int:
	var scaler: int = round(num / GameData.game_settings["NumOfTanks"]) # warning-ignore:narrowing_conversion
	return scaler

static func sort_decending(a, b) -> bool:
	if a[0] > b[0]:
		return true
	return false
