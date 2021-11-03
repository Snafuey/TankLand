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
	"NumOfTanks": 2,
	"Rounds": 10,
	"Walls": ["Static", "Bounce", "Wrap", "Random"],
	"CurrentWalls": "Wrap",
	"MoneyAmounts": [0, 5000, 10000, 50000, 100000],
	"StartingMoney": 0 }

var money_table: Dictionary = {
	"Win": 5000,
	"Kill": 1000,
	"Suicied": -1500 }

var tank_data: Dictionary = {}

var Player1_Items: Inventory = preload("res://resources/inventories/Player1.tres")
var Player2_Items: Inventory = preload("res://resources/inventories/Player2.tres")
#var Player3_Items: Inventory = preload("res://resources/inventories/Player3.tres")
#var Player4_Items: Inventory = preload("res://resources/inventories/Player4.tres")
#var Player5_Items: Inventory = preload("res://resources/inventories/Player5.tres")
#var Player6_Items: Inventory = preload("res://resources/inventories/Player6.tres")
#var Player7_Items: Inventory = preload("res://resources/inventories/Player7.tres")

var all_inventories: Dictionary = {"Player1": Player1_Items, "Player2": Player2_Items}

#																"Player1": {
#																	"Name": "Kurt",
#																	"Color": Color.darkred,
#																	"Tank": "Tank1",
#																	"Controller": "Player",
#																	"Money": 10000, 
#																	"Earnings": 10000, 
#																	"Kills": 4,
#																	"TotalKills": 5,
#																	"Suicide": 0,
#																	"Weapon" },
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
var battle_music: Array = ["res://assets/audio/battle-music-1.ogg",
													"res://assets/audio/battle-music-2.ogg",
													"res://assets/audio/battle-music-3.ogg"]



func _ready() -> void:
	pass
#	Player1_Items = load("res://resources/inventories/Player1.tres")
#	var all_inv_keys: Array = all_inventories.keys()
#	var player_inventory: Resource = all_inventories[all_inv_keys[0]]
#	print(player_inventory)
#
#	print(player_inventory.weapons)
#	print(player_inventory.weapons["Baby Missile"])
#	var item_data: Resource = player_inventory.weapons["Baby Missile"]["Item"]
#	print(player_inventory.weapons["Baby Missile"]["Amount"])
#	print(item_data.name)
#	print(item_data.damage)
#	player_inventory.equipped_weapon = item_data
#	var equipped_item: Resource = player_inventory.equipped_weapon
#	print(player_inventory.equipped_weapon.name)
#	Player1_Items.weapons["Slot" + str(keys.size() + 1)] = {"Item": "Test", "Amount": 50}
#	for slot in Player1_Items.weapons.keys():
#		if Player1_Items.weapons[slot]["Amount"] != 0:
#			print(Player1_Items.weapons[slot])


func new_round_set_tank_data() -> void:
	var player_list: Array = Utils.get_tank_data_player_keys()
	if player_list.empty():
		return
	for player in player_list:
		tank_data[player]["Suicied"] = 0
		tank_data[player]["Kills"] = 0
#	for i in game_settings["NumOfTanks"]:
#		tank_data["Player" + str(i + 1)]["Suicied"] = 0
#		tank_data["Player" + str(i + 1)]["Kills"] = 0

func replay_game_set_tank_data() -> void:
	var player_list: Array = Utils.get_tank_data_player_keys()
	if player_list.empty():
		return
	for player in player_list:
		tank_data[player]["Money"] = 0
		tank_data[player]["Earnings"] = 0
		tank_data[player]["Kills"] = 0
		tank_data[player]["TotalKills"] = 0
		tank_data[player]["Suicide"] = 0
	clear_inventories()
#	for i in game_settings["NumOfTanks"]:
#		tank_data["Player" + str(i + 1)]["Money"] = 0
#		tank_data["Player" + str(i + 1)]["Earnings"] = 0
#		tank_data["Player" + str(i + 1)]["Kills"] = 0
#		tank_data["Player" + str(i + 1)]["TotalKills"] = 0
#		tank_data["Player" + str(i + 1)]["Suicide"] = 0

func clear_tank_data() -> void:
	tank_data = {}
		
func clear_inventories() -> void:
	all_inventories = {}
