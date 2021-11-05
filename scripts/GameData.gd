extends Node

const GRAVITY = 118

enum GAME_STATES {
	MAIN_MENU,
	OPTIONS_MENU,
	TANK_CREATION,
	SHOP
	BATTLE,
	ROUND_RANKING,
	PAUSE,
	FINAL_SCORE }

var terrain_colors: Array = [
	Color.peru, 
	Color.darkgreen, 
	Color.saddlebrown, 
	Color.gainsboro]

var tank_colors: Array = [
	Color.darkred, 
	Color.green, 
	Color.blue, 
	Color.darkmagenta, 
	Color.yellow, 
	Color.darkorange, 
	Color.maroon]

var game_settings: Dictionary = {
	"NumOfTanks": 2,
	"Rounds": 10,
	"Walls": ["Static", "Bounce", "Wrap", "Random"],
	"CurrentWalls": "Wrap",
	"MoneyAmounts": [0, 5000, 10000, 50000, 100000],
	"StartingMoney": 100000 }

var money_table: Dictionary = {
	"Win": 5000,
	"Kill": 1000,
	"Suicied": -1500 }

var tank_data: Dictionary = {}
#"Player1": {
	#	"Name": "Kurt",
	#	"Color": Color.darkred,
	#	"Tank": "Tank1",
	#	"Controller": "Player",
	#	"Money": 10000, 
	#	"Earnings": 10000, 
	#	"Kills": 4,
	#	"TotalKills": 5,
	#	"Suicide": 0,
	#	"Weapon" }

var all_inventories: Dictionary = {}

var angle_SFX_sounds: Array = [
	"res://assets/audio/angle1.wav", 
	"res://assets/audio/angle2.wav", 
	"res://assets/audio/angle3.wav", 
	"res://assets/audio/angle4.wav", 
	"res://assets/audio/angle5.wav"]

var battle_music: Array = [
	"res://assets/audio/battle-music-1.ogg", 
	"res://assets/audio/battle-music-2.ogg", 
	"res://assets/audio/battle-music-3.ogg"]

func _ready() -> void:
	pass


func new_round_set_tank_data() -> void:
	var player_list: Array = Utils.get_tank_data_keys()
	if player_list.empty():
		return
	for player in player_list:
		tank_data[player]["Suicied"] = 0
		tank_data[player]["Kills"] = 0


func replay_game_set_tank_data() -> void:
	var player_list: Array = Utils.get_tank_data_keys()
	if player_list.empty():
		return
	clear_inventories()
	for player in player_list:
		tank_data[player]["Money"] = 0
		tank_data[player]["Earnings"] = 0
		tank_data[player]["Kills"] = 0
		tank_data[player]["TotalKills"] = 0
		tank_data[player]["Suicide"] = 0
		set_default_player_inventory(player)


func set_default_player_inventory(player_slot: String) -> void:
	var player_items: Inventory = load("res://resources/inventories/" + player_slot + ".tres")
	all_inventories[player_slot] = player_items


func clear_tank_data() -> void:
	tank_data = {}


func clear_inventories() -> void:
	all_inventories = {}
