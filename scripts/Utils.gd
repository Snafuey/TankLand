extends Node

static func get_tank_slot(tank_name: String) -> String:
	var tank_slot: Array = tank_name.split("-")
	return tank_slot[0]

static func build_tank_node_name(player_slot: String) -> String:
	var tank_node_name: String = player_slot + "-" + GameData.tank_data[player_slot]["Name"]
	return tank_node_name

static func get_player_name_from_slot(player_slot: String) -> String:
	var player_name: String = GameData.tank_data[player_slot]["Name"]
	return player_name

static func get_tank_data_player_keys() -> Array:
	var player_list: Array = GameData.tank_data.keys()
	return player_list

#static func get_player_equipped_weapon(player_slot: String) -> Item:
#	var player_inventory: Inventory = GameData.all_inventories[player_slot]
#	var equipped_item: Item = player_inventory.equipped_weapon
#	return equipped_item

static func get_player_inventory(player_slot: String) -> Inventory:
	var player_inventory: Inventory = GameData.all_inventories[player_slot]
	return player_inventory

static func get_random_spawn_index(index: int) -> int:
	randomize()
	var new_index: int = round(index + rand_range(-9 , 9)) # warning-ignore:narrowing_conversion
	return new_index

static func get_tank_num_scaler(num: int) -> int:
# warning-ignore:narrowing_conversion
	var scaler: int = round(num / GameData.game_settings["NumOfTanks"])
	return scaler

static func get_random_index_range(start: int, end: int) -> int:
	randomize()
	var new_index: int = round(rand_range(start, end)) # warning-ignore:narrowing_conversion
	return new_index

static func get_tank_data_by_type(type: String) -> Array:
	var ranks: Array = []
	var player_list: Array = Utils.get_tank_data_player_keys()
	for player in player_list:
		var value: int = GameData.tank_data[player][type]
		ranks.append([value, player])
#	for i in GameData.game_settings["NumOfTanks"]:
#		var value: int = GameData.tank_data["Player" + str(i + 1)][type]
#		var tank_slot: String = "Player" + str(i + 1)
#		ranks.append([value, tank_slot])
	return ranks

static func sort_decending(a, b) -> bool:
	if a[0] > b[0]:
		return true
	return false

static func get_tank_script_path(num: String) -> String:
#	var path = "res://scripts/" + GameData.tank_data["Player" + num]["Controller"] + ".gd"
	var path = "res://scripts/" + GameData.tank_data[num]["Controller"] + ".gd"
	return path

func get_tank_scene_path(num: String) -> String:
#	var path = "res://scenes/tanks/" + GameData.tank_data["Player" + num]["Tank"] + ".tscn"
	var path = "res://scenes/tanks/" + GameData.tank_data[num]["Tank"] + ".tscn"
	return path
