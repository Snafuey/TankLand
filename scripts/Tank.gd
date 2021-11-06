extends KinematicBody2D

const PROJECTILE = preload("res://scenes/projectiles/Projectile.tscn")
const SHOOT_SFX = preload("res://assets/audio/heavy-artillery-shot.wav")

onready var tankSprite: Sprite = $TankSprite
onready var barrel: Sprite = $TankSprite/Barrel
onready var muzzel: Position2D = $TankSprite/Barrel/Muzzle
onready var muzzelFlash: Particles2D = $TankSprite/Barrel/MuzzleFlash
onready var tankSFX: AudioStreamPlayer = $TankSFX
onready var line: Line2D = $TankSprite/Barrel/TrajectoryLine

var tank_color: Color

var velocity: Vector2 = Vector2.ZERO

var power: int = 1 setget set_power
var angle: float = 0.0 setget set_angle
var max_health: int = 100
var current_health: int setget set_current_health

var is_active: bool = false setget set_as_active
var allow_inputs: bool = false
var allow_menu: bool = false

func init_spawn_data(player_slot: String, spawn_pos: Vector2) -> void:
	var inventory: Inventory = Utils.get_player_inventory(player_slot)
	inventory.equipped_weapon = preload("res://resources/items/BabyMissile.tres")
	self.name = Utils.build_tank_node_name(player_slot)
	tank_color =  Utils.get_player_color(player_slot)
	self.global_position = spawn_pos + Vector2(0 , -10)


func _ready() -> void:
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
		velocity.y += GameData.GRAVITY * delta
	barrel.rotation_degrees = angle

func shoot() -> void:
	var inventory: Inventory = Utils.get_player_inventory(Utils.get_player_slot(self.name))
	var has_ammo: bool = check_ammo(inventory)
	if not has_ammo:
		allow_inputs = true
		allow_menu = true
		return
	var angle_rad: float = deg2rad(angle)
	var equipped_weapon: Item = inventory.equipped_weapon
	var projectile = PROJECTILE.instance()
	projectile.connect("bullet_finished", self, "finish_turn")
	projectile.global_position = muzzel.global_position
	find_parent("BattleField").add_child(projectile)
	projectile.initialize(Vector2(cos(angle_rad), sin(angle_rad)) * power, equipped_weapon)
	muzzelFlash.emitting = true
	tankSFX.set_stream(SHOOT_SFX)
	tankSFX.play()
	inventory.use_weapon_ammo(equipped_weapon.name, 1)

	
func check_ammo(inventory: Inventory) -> bool:
	var ammo_amount: int = inventory.get_weapon_amount(inventory.equipped_weapon.name)
	print(ammo_amount)
	if ammo_amount > 0:
		return true
	return false

func set_as_active(value: bool) -> void:
	is_active = value
	allow_inputs = value
	allow_menu = value
	if is_active:
		Events.emit_signal("new_active_tank", 
			power, angle, current_health, Utils.get_player_slot(self.name))


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


#var max_points: int = 300
#func _process(delta: float) -> void:
#	if is_active:
#		line.visible = true
#		line.set_as_toplevel(true)
#		line.clear_points()
#		var angle_rad: float = deg2rad(angle)
#		var pos: Vector2 = muzzel.global_position
#		var vel: Vector2 = Vector2(cos(angle_rad), sin(angle_rad)) * power
#		for i in max_points:
#			line.add_point(pos)
#			vel.y += GameData.GRAVITY * delta
#			pos += vel * delta
#	else:
#		line.visible = false
