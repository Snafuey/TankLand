extends Node

signal walls_changed(type)

const TANK_PATH: String = "res://scenes/tanks/"
const SCRIPT_PATH: String = "res://scripts/"
const FINAL_SCORE: String = "res://scenes/menus/FinalScore.tscn"
const RANKINGS = preload("res://scenes/menus/Rankings.tscn")
const TERRAIN = preload("res://scenes/level/Terrain.tscn")

onready var turnQueue = $TurnQueue
onready var sceneManager = find_parent("GameMain")

var death_order: Array = []
var total_rounds: int = GameData.game_settings["Rounds"] setget , get_total_rounds
var current_round: int setget set_current_round, get_current_round
var walls: String setget set_walls

func _ready() -> void:
	init_battle()

func init_battle() -> void:
	turnQueue.connect("winner", self, "round_won")
	self.current_round = 1
	self.walls = GameData.game_settings["CurrentWalls"]


func round_won(tank: KinematicBody2D):
	var player_slot = GameData.get_player_slot(tank.name)
	death_order.push_front(player_slot)
	GameData.player_data[player_slot]["Money"] += GameData.money_table["Win"]
	GameData.player_data[player_slot]["Earnings"] += GameData.money_table["Win"]
	var rankings = RANKINGS.instance()
	add_child(rankings)
	

func apply_kill(dead_tank: String) -> void:
	print("Signal from tank triggered apply_kill in battle main")
	var killer = turnQueue.get_active_tank_name()
	var killers_slot = GameData.get_player_slot(killer)
#	yield(get_tree(), "idle_frame")
	if dead_tank == killer:
		GameData.player_data[killers_slot]["Suicide"] += 1
		GameData.player_data[killers_slot]["Money"] += GameData.money_table["Suicied"]
		GameData.player_data[killers_slot]["Earnings"] += GameData.money_table["Suicied"]
		return
	GameData.player_data[killers_slot]["Kills"] += 1
	GameData.player_data[killers_slot]["TotalKills"] += 1
	GameData.player_data[killers_slot]["Money"] += GameData.money_table["Kill"]
	GameData.player_data[killers_slot]["Earnings"] += GameData.money_table["Kill"]


func set_new_round() -> void:
	self.current_round += 1
	queue_tanks()
	queue_terrain()
	GameData.new_round_clear_data()
	spawn_new_terrain()

func queue_tanks() -> void:
	var tanks = turnQueue.get_children()
	for tank in tanks:
		tank.queue_free()

func queue_terrain() -> void:
	var terrain = $Terrain
	terrain.queue_free()

func spawn_new_terrain() -> void:
	var new_terrain = TERRAIN.instance()
	new_terrain.name = "Terrain"
	yield(get_tree().create_timer(0.2), "timeout")
	add_child(new_terrain)


func set_walls(value: String) -> void:
	walls = value
	emit_signal("walls_changed", walls)

func set_current_round(value: int) -> void:
	current_round = value
	if current_round > total_rounds:
		sceneManager.transition_scene(FINAL_SCORE)


func get_current_round() -> int:
	return current_round

func get_total_rounds() -> int:
	return total_rounds


func set_tank_spawn_points(points: Array) -> void: #called by signal in Terrian passing spawn positions
	var scaler = round(points.size() / GameData.game_settings["Players"])
	var last_index: int
	for i in GameData.game_settings["Players"]:
		if i == 0:
			var index = scaler / 2
			last_index = index
			var rand_index = GameData.get_random_spawn_index(index)
			spawn_tank_set_data(str(i + 1), points[rand_index])
		else:
			var index = (last_index + scaler)
			last_index = index
			var rand_index = GameData.get_random_spawn_index(index)
			spawn_tank_set_data(str(i + 1), points[rand_index])
	yield(get_tree(), "idle_frame")
	turnQueue.initialize(death_order)

func spawn_tank_set_data(index: String, spawn_pos: Vector2) -> void:
	var tank = load(get_tank_path(index)).instance()
	yield(get_tree(), "idle_frame")
	tank.set_script(load(get_script_path(index)))
	tank.name = "Player" + index + "-" + GameData.player_data["Player" + index]["Name"] 
	tank.tank_color =  GameData.player_data["Player" + index]["Color"]
	turnQueue.add_child(tank)
	tank.global_position = spawn_pos + Vector2(0 , -10)

func get_script_path(num: String) -> String:
	var path = SCRIPT_PATH + GameData.player_data["Player" + num]["Controller"] + ".gd"
	return path

func get_tank_path(num: String) -> String:
	var path = TANK_PATH + GameData.player_data["Player" + num]["Tank"] + ".tscn"
	return path
