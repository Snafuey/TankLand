extends KinematicBody2D

const BULLET = preload("res://scenes/projectiles/Bullet.tscn")
const SHOOT_SFX = preload("res://assets/audio/heavy-artillery-shot.wav")

onready var tankSprite: Sprite = $TankSprite
onready var barrel: Sprite = $TankSprite/Barrel
onready var muzzel: Position2D = $TankSprite/Barrel/Muzzle
onready var muzzelFlash: Particles2D = $TankSprite/Barrel/MuzzleFlash
onready var tankSFX: AudioStreamPlayer = $TankSFX

var tank_color: Color
var gravity: float = 9.8
var velocity: Vector2 = Vector2.ZERO

var power: int = 1 setget set_power
var angle: float = 0.0 setget set_angle
var max_health: int = 100
var current_health: int setget set_current_health

var is_active: bool = false setget set_as_active
var can_process_turn: bool = false

func init_spawn_data(slot_index: String, spawn_pos: Vector2) -> void:
	self.name = "Player" + slot_index + "-" + GameData.tank_data["Player" + slot_index]["Name"] 
	tank_color =  GameData.tank_data["Player" + slot_index]["Color"]
	self.global_position = spawn_pos + Vector2(0 , -10)

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
	var bullet = BULLET.instance()
	bullet.connect("bullet_finished", self, "finish_turn")
	bullet.global_position = muzzel.global_position
	find_parent("BattleField").add_child(bullet)
	bullet.apply_central_impulse(Vector2(cos(angle_rad), sin(angle_rad)) * power)
	muzzelFlash.emitting = true
	tankSFX.set_stream(SHOOT_SFX)
	tankSFX.play()

func set_as_active(value: bool) -> void:
	is_active = value
	can_process_turn = value
	if is_active:
		Events.emit_signal("tank_activated", power, angle, current_health, self)


func set_current_health(value: int) -> void:
	current_health = value
	if current_health > 0:
		Events.emit_signal("tank_health_changed", current_health)
		return
	die()

func set_power(value: int) -> void:
	power = value
	power = clamp(power, 1, 500) # warning-ignore:narrowing_conversion
	Events.emit_signal("tank_power_changed", power)

func set_angle(value: float) -> void:
	angle = value
	angle = clamp(angle, -180, 0)
	Events.emit_signal("tank_angle_changed", angle)

func finish_turn() -> void:
	Events.emit_signal("tank_turn_finished")

func die() -> void:
	Events.emit_signal("tank_died", self)
	self.queue_free()
