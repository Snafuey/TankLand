extends Node

var earth_colors: Dictionary = {
	"Sand": Color.peru,
	"Grass": Color.darkgreen,
	"Dirt": Color.saddlebrown,
	"Snow": Color.gainsboro }

var tank_colors: Dictionary = {
	"Red": Color.darkred,
	"Green": Color.green,
	"Blue": Color.blue,
	"Purple": Color.darkmagenta,
	"Yellow": Color.yellow,
	"Orange": Color.darkorange,
	"Pink": Color.maroon }

var game_settings: Dictionary = {
	"Players": 2,
	"Rounds": 10,
	"Walls": ["Static", "Bounce", "Wrap", "Random"],
	"CurrentWalls": "Bounce",
	"MoneyAmounts": [0, 5000, 10000, 50000, 100000],
	"StartingMoney": 0 }

var money_table: Dictionary = {
	"Win": 5000,
	"Kill": 1000,
	"Suicied": -1500 }

var player_data: Dictionary = {}
#																"Player1": {
#																	"Name": "Kurt",
#																	"Color": Color.darkred,
#																	"Tank": "Tank1",
#																	"Controller": "Player",
#																	"Money": 10000, 
#																	"Earnings": 10000, 
#																	"Kills": 4,
#																	"TotalKills": 5,
#																	"Suicide": 0 },
#																"Player2": {
#																	"Name": "Amber",
#																	"Color": Color.green,
#																	"Tank": "Tank1",
#																	"Controller": "Player",
#																	"Money": 1000, 
#																	"Earnings": 1000, 
#																	"Kills": 2,
#																	"TotalKills": 2,
#																	"Suicide": 0 },
#																"Player3": {
#																	"Name": "Kaden",
#																	"Color": Color.blue,
#																	"Tank": "Tank1",
#																	"Controller": "Player",
#																	"Money": 12000, 
#																	"Earnings": 12000, 
#																	"Kills": 3,
#																	"TotalKills": 6,
#																	"Suicide": 0 },
#																"Player4": {
#																	"Name": "Paxton",
#																	"Color": Color.darkmagenta,
#																	"Tank": "Tank1",
#																	"Controller": "Player",
#																	"Money": 100, 
#																	"Earnings": 7000, 
#																	"Kills": 9,
#																	"TotalKills": 10,
#																	"Suicide": 0 } }
var angle_SFX_sounds: Array = ["res://assets/audio/angle1.wav",
															"res://assets/audio/angle2.wav",
															"res://assets/audio/angle3.wav",
															"res://assets/audio/angle4.wav",
															"res://assets/audio/angle5.wav"]
var battle_music: Array = ["res://assets/audio/battle-music-1.wav",
													"res://assets/audio/battle-music-2.wav",
													"res://assets/audio/battle-music-3.wav"]

static func sort_decending(a, b) -> bool:
	if a[0] > b[0]:
		return true
	return false

func get_player_slot(tank_name: String) -> String:
	var player_slot = tank_name.split("-")
	return player_slot[0]

func get_full_tank_name(player_slot: String) -> String:
	var player_name = player_slot + "-" + player_data[player_slot]["Name"]
	return player_name

func new_round_clear_data() -> void:
	for i in game_settings["Players"]:
		player_data["Player" + str(i + 1)]["Suicied"] = 0
		player_data["Player" + str(i + 1)]["Kills"] = 0

func restart_game_clear_data() -> void:
	for i in game_settings["Players"]:
		player_data["Player" + str(i + 1)]["Money"] = 0
		player_data["Player" + str(i + 1)]["Earnings"] = 0
		player_data["Player" + str(i + 1)]["Kills"] = 0
		player_data["Player" + str(i + 1)]["TotalKills"] = 0
		player_data["Player" + str(i + 1)]["Suicide"] = 0

func new_game_clear_data() -> void:
	player_data = {}
		
func build_ranks_by_type(by_type: String) -> Array:
	var ranks: Array = []
	for i in game_settings["Players"]:
		var value: int = player_data["Player" + str(i + 1)][by_type]
		var player_slot: String = "Player" + str(i + 1)
		ranks.append([value, player_slot])
	ranks.sort_custom(self, "sort_decending")
	return ranks

func get_random_spawn_index(index: int) -> int:
	randomize()
	var new_index: int = round(index + rand_range(-9 , 9)) # warning-ignore:narrowing_conversion
	return new_index

static func get_random_index_range(start: int, end: int) -> int:
	randomize()
	var new_index: int = round(rand_range(start, end))
	return new_index
