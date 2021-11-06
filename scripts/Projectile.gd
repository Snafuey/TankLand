extends KinematicBody2D

signal bullet_finished()
signal direct_hit(tank_ref, damage_value) # warning-ignore:unused_signal

const SMALL_EXPLOSION = preload("res://scenes/effects/SmallExplosion.tscn")

export(int) var radius = 20
#export(int) var damage = 100

onready var collisionShape = $CollisionShape2D
onready var turnQueue = get_parent().get_node("TurnQueue")

var screensize: Vector2
var velocity: Vector2 = Vector2.ZERO
var weapon_data: Item


func _ready() -> void:
	screensize = get_viewport_rect().size
	var err: int = connect("direct_hit", turnQueue, "append_damage_queue")
	if err:
		printerr("Connection Failed " + str(err))

func initialize(vel: Vector2, weapon_used: Item) -> void:
	velocity = vel
	weapon_data = weapon_used
	

func _physics_process(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	velocity.y += GameData.GRAVITY * delta
	if collision:
		var body: Object = collision.get_collider()
		if body.is_in_group("walls"): 
			if Utils.get_current_walls() == "Bounce":
				velocity = velocity.bounce(collision.normal)
			else:
				handle_collision(body)
		else:
			handle_collision(body)
			self.visible = false

	if self.global_position.x > screensize.x:
		self.global_position.x = 0
	if self.global_position.x < 0:
		self.global_position.x = screensize.x


func handle_collision(body: Object) -> void:
	yield(get_tree(), "physics_frame")
	self.set_physics_process(false)
	
	if body.is_in_group("terrainCollision"):
		adjust_wrap_on_terrian_collison()
		yield(spawn_explosion(), "completed")
		body.get_parent().destroy_terrain(self.global_position, radius)
	
	if body.is_in_group("tank"):
		emit_signal("direct_hit", body, weapon_data.damage)
		yield(spawn_explosion(), "completed")
	
	if body.is_in_group("walls"):
		yield(spawn_explosion(), "completed")
		
	bullet_finsihed()


func adjust_wrap_on_terrian_collison() -> void:
	if self.global_position.x >= screensize.x:
		self.global_position.x = 0
		return
	if self.global_position.x <= 0:
		self.global_position.x = screensize.x


func spawn_explosion() -> void:
	self.radius = weapon_data.explosion_rad
	var explosion = weapon_data.explosion_scene.instance()
	explosion.global_position = self.global_position
	get_parent().add_child(explosion)
	yield(explosion, "explosion_finished")
	

func bullet_finsihed() -> void:
	emit_signal("bullet_finished")
	self.queue_free()
	
