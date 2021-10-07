class_name Tank
extends KinematicBody2D

signal new_turn_hud_change(power, angle, health)
signal power_changed(value)
signal angle_changed(value)
signal health_changed(value)
signal tank_killed(tank_name)
signal turn_finsihed()

const BULLET = preload("res://scenes/projectiles/Bullet.tscn")
const SHOOT_SFX: String = "res://assets/audio/heavy-artillery-shot.wav"

onready var tankSprite: Sprite = $TankSprite
onready var barrel: Sprite = $TankSprite/Barrel
onready var muzzel: Position2D = $TankSprite/Barrel/Muzzle
onready var muzzelFlash: Particles2D = $TankSprite/Barrel/MuzzleFlash
onready var sceneManager: Node2D = find_parent("GameMain")

var tank_color: Color
var gravity: float = 9.8
var velocity: Vector2 = Vector2.ZERO

var power: int = 1 setget set_power
var angle: float = 0.0 setget set_angle
var max_health: int = 100
var current_health: int setget set_current_health

var is_active: bool = false setget set_as_active
var can_process_turn: bool = false

func _ready() -> void:
	randomize()
	tankSprite.self_modulate = tank_color
	barrel.self_modulate = tank_color
	self.current_health = max_health 
	self.power = 200
	self.angle = -32.0


func _physics_process(delta: float) -> void:
	var collision: KinematicCollision2D
	collision = move_and_collide(velocity * delta, false)
	if collision:
		velocity.y = 0
	else:
		velocity.y += gravity
	barrel.rotation_degrees = angle

func shoot() -> void:
	var angle_rad: float = deg2rad(angle)
	var bullet: RigidBody2D = BULLET.instance()
	bullet.global_position = muzzel.global_position
	bullet.connect("bullet_finished", self, "finished_turn") # warning-ignore:return_value_discarded
	find_parent("BattleField").add_child(bullet)
	bullet.apply_central_impulse(Vector2(cos(angle_rad), sin(angle_rad)) * power)
	sceneManager.play_SFX(SHOOT_SFX)
	muzzelFlash.emitting = true
#	TankSFX.set_stream(SHOOT_SFX)
#	TankSFX.play()

func set_as_active(value: bool) -> void:
	emit_signal("new_turn_hud_change", power, angle, current_health, self.name)
	is_active = value
	can_process_turn = value
#	print(str(self.name) + " active status is " + str(is_active))

func set_current_health(value: int) -> void:
	current_health = value
	if current_health > 0:
		emit_signal("health_changed", current_health)
		return
	die()

func set_power(value: int) -> void:
	power = value
	power = clamp(power, 1, 500) # warning-ignore:narrowing_conversion
	emit_signal("power_changed", power)

func set_angle(value: float) -> void:
	angle = value
	angle = clamp(angle, -180, 0)
	emit_signal("angle_changed", angle)

func finished_turn() -> void:
	emit_signal("turn_finsihed")

func die() -> void:
	emit_signal("tank_killed", self.name)
	var battleMain = find_parent("BattleField")
	var player_slot = GameData.get_player_slot(self.name)
	battleMain.death_order.append(player_slot)
	self.queue_free()
