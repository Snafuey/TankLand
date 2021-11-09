extends Node

enum GAME_STATES {
	MAIN_MENU,
	OPTIONS_MENU,
	TANK_CREATION,
	SHOP
	BATTLE,
	ROUND_RANKING,
	PAUSE,
	FINAL_SCORE }


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


"""
Game Values
"""

const GRAVITY = 118

"""
Game Colors
"""

const terrain_colors: Array = [
	Color.peru, 
	Color.darkgreen, 
	Color.saddlebrown, 
	Color.gainsboro]

const tank_colors: Array = [
	Color.darkred, 
	Color.green, 
	Color.blue, 
	Color.darkmagenta, 
	Color.yellow, 
	Color.darkorange, 
	Color.maroon]

"""
Game Sounds
"""

const MAIN_MENU_MUSIC: = preload("res://assets/audio/music/main-menu-music.ogg")
const TANK_CREATION_MUSIC = preload("res://assets/audio/music/tank-creation-music.ogg")
const SHOP_MUSIC = preload("res://assets/audio/music/shop-music.ogg")
const BATTLE_MUSIC_1 = preload("res://assets/audio/music/battle-music-1.ogg")
const BATTLE_MUSIC_2 = preload("res://assets/audio/music/battle-music-2.ogg")
const BATTLE_MUSIC_3 = preload("res://assets/audio/music/battle-music-3.ogg")

const HOVER_SFX1 = preload("res://assets/audio/ui/button-hover-1.wav")
const HOVER_SFX2 = preload("res://assets/audio/ui/button-hover-2.wav")
const PRESSED_SFX = preload("res://assets/audio/ui/button-pressed.wav")
const CONFIRM_SFX = preload("res://assets/audio/ui/confirm.wav")
const DECLINE_SFX = preload("res://assets/audio/ui/decline.wav")

const TANK_SFX_ANGLE_1 = preload("res://assets/audio/tank/angle-change-1.wav")
const TANK_SFX_ANGLE_2 = preload("res://assets/audio/tank/angle-change-2.wav")
const TANK_SFX_POWER_1 = preload("res://assets/audio/tank/tank-power-1.wav")
const TANK_SFX_POWER_2 = preload("res://assets/audio/tank/tank-power-2.wav")

var battle_music_list: Array = [BATTLE_MUSIC_1, BATTLE_MUSIC_2, BATTLE_MUSIC_3]
onready var button_hover_list: Array = [HOVER_SFX1, HOVER_SFX2]
var angle_SFX_list: Array = [TANK_SFX_ANGLE_1, TANK_SFX_ANGLE_2]
var power_SFX_list: Array = [TANK_SFX_POWER_1, TANK_SFX_POWER_2]

"""
Game Textures
"""
const NORMAL_TEXTURE = preload("res://assets/sprites/Menu Button Normal.png")
const HOVER_TEXTURE = preload("res://assets/sprites/Menu Button Hover.png")
const PRESSED_TEXTURE = preload("res://assets/sprites/Menu Button Pressed.png")
