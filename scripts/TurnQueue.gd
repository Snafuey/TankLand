class_name TurnQueue
extends Node

signal winner(tank)

onready var battleFieldHud: CanvasLayer = get_parent().get_node("BattleFieldHud")
onready var battleField: Node = get_parent()

var active_tank: KinematicBody2D

func initialize(order: Array) -> void:
	var tanks: Array = get_children()
	for tank in tanks:
		make_tank_signal_connections(tank)
	if order.size() != 0:
		set_tank_order(order)
#	yield(get_tree(), "idle_frame")
	active_tank = get_child(0)
	active_tank.is_active = true		

func set_tank_order(order: Array) -> void:
	for i in GameData.game_settings["Players"]:
		var tank: KinematicBody2D = get_node(GameData.get_full_tank_name(order[i]))
		move_child(tank, 0)
	battleField.death_order = []
		
	
func next_turn() -> void:
	yield(get_tree().create_timer(1), "timeout")
	var child_count: int = get_child_count()
	if child_count == 1:
		var winner: KinematicBody2D = get_child(0)
		winner.is_active = false
		emit_signal("winner", winner)
		return
#	yield(get_tree(), "idle_frame")
	active_tank.is_active = false
	var new_tank: int = (active_tank.get_index() + 1) % child_count
	active_tank = get_child(new_tank)
	active_tank.is_active = true
	make_tank_signal_connections(active_tank)
	

func get_active_tank_name() -> String:
	var active_tank_name = active_tank.name
	return active_tank_name


func make_tank_signal_connections(tank: KinematicBody2D) -> void:
	if not tank.is_connected("turn_finsihed", self, "next_turn"):
		tank.connect("turn_finsihed", self, "next_turn") # warning-ignore:return_value_discarded
	if not tank.is_connected("power_changed", battleFieldHud, "change_power"):
		tank.connect("power_changed", battleFieldHud, "change_power") # warning-ignore:return_value_discarded
	if not tank.is_connected("angle_changed", battleFieldHud, "change_angle"):
		tank.connect("angle_changed", battleFieldHud, "change_angle") # warning-ignore:return_value_discarded
	if not tank.is_connected("health_changed", battleFieldHud, "change_health"):
		tank.connect("health_changed", battleFieldHud, "change_health") # warning-ignore:return_value_discarded
	if not tank.is_connected("new_turn_hud_change", battleFieldHud, "new_turn"):
		tank.connect("new_turn_hud_change", battleFieldHud, "new_turn") # warning-ignore:return_value_discarded
	if not tank.is_connected("tank_killed", battleField, "apply_kill"):
		tank.connect("tank_killed", battleField, "apply_kill") # warning-ignore:return_value_discarded
	
