extends Node

const INVENTORY_SCENE = preload("res://scenes/menus/Inventory.tscn")

onready var turnQueue: Node = $TurnQueue
onready var terrain: Node = $Terrain
onready var walls: Node = $Walls
onready var battleHud: Node = $BattleHud

var death_order: Array = [] #Player slot index 0 is 1st place
var total_rounds: int
var current_round: int = 0 setget set_current_round, get_current_round
var current_walls: String setget set_walls

func _ready() -> void:
	var err: int = Events.connect("terrain_finished", self, "terrain_finished")
	if err:
		printerr("Connection Failed " + str(err))
	err = Events.connect("turnQueue_tank_spawn_finished", self, "turnQueue_tanks_ready")
	if err:
		printerr("Connection Failed " + str(err))
	err = Events.connect("tank_died", self, "handle_death")
	if err:
		printerr("Connection Failed " + str(err))
	err = Events.connect("turnQueue_round_finished", self, "end_round" )
	if err:
		printerr("Connection Failed " + str(err))
	err = Events.connect("inventory_toggled", self, "toggle_inventory")
	if err:
		printerr("Connection Failed " + str(err))
	total_rounds = GameData.game_settings["Rounds"]
	self.current_round += 1
	init_new_battle()

func init_new_battle() -> void:
	var tanks: Array = turnQueue.get_children()
	if tanks.size() != 0:
		queue_tanks(tanks)
		yield(get_tree(), "idle_frame")
	battleHud.get_child(0).visible = true
	self.current_walls = GameData.game_settings["CurrentWalls"]
	terrain.init_new_terrain()
	
func terrain_finished(terrain_points: Array) -> void:
	turnQueue.spawn_tanks(terrain_points)

func turnQueue_tanks_ready() -> void:
	if death_order.size() > 0:
		turnQueue.set_tank_order(death_order)
		death_order = []
	else:
		turnQueue.start_round()

func set_walls(type: String) -> void:
	current_walls = type
	GameData.game_settings["CurrentWalls"] = type
	walls.set_walls(current_walls)

func set_current_round(value: int) -> void:
	current_round = value
	if current_round > total_rounds:
		battleHud.get_child(0).visible = false
		Events.emit_signal("change_game_state", GameData.GAME_STATES.FINAL_SCORE)

func get_current_round() -> int:
	return current_round

func handle_death(dead_tank: KinematicBody2D) -> void:
	var dead_tank_slot: String = Utils.get_player_slot(dead_tank.name)
	var killer_slot: String = Utils.get_player_slot(turnQueue.get_active_tank_name())
	death_order.push_front(dead_tank_slot)
	if dead_tank_slot == killer_slot:
		GameData.tank_data[dead_tank_slot]["Suicide"] += 1
		GameData.tank_data[dead_tank_slot]["Money"] += GameData.money_table["Suicied"]
		GameData.tank_data[dead_tank_slot]["Earnings"] += GameData.money_table["Suicied"]
		return
	GameData.tank_data[killer_slot]["Kills"] += 1
	GameData.tank_data[killer_slot]["TotalKills"] += 1
	GameData.tank_data[killer_slot]["Money"] += GameData.money_table["Kill"]
	GameData.tank_data[killer_slot]["Earnings"] += GameData.money_table["Kill"]

func end_round(tank: KinematicBody2D) -> void:
	if tank != null:
		var tank_slot: String = Utils.get_player_slot(tank.name)
		death_order.push_front(tank_slot)
		GameData.tank_data[tank_slot]["Money"] += GameData.money_table["Win"]
		GameData.tank_data[tank_slot]["Earnings"] += GameData.money_table["Win"]
	if current_round == total_rounds:
		self.current_round += 1
		return
	Events.emit_signal("change_game_state", GameData.GAME_STATES.ROUND_RANKING)


func toggle_inventory(player_slot: String) -> void:
	var is_open: Node = get_node_or_null("Inventory")
	var active_tank: KinematicBody2D = turnQueue.active_tank
	if is_open:
		is_open.queue_free()
		active_tank.allow_inputs = true
		return
	active_tank.allow_inputs = false
	var inventory = INVENTORY_SCENE.instance()
	inventory.assign_player_slot(player_slot)
	self.add_child(inventory)
	
func queue_tanks(tanks: Array) -> void:
	for tank in tanks:
		tank.queue_free()
		
