extends KinematicBody2D

signal bullet_finished()

const SMALL_EXPLOSION = preload("res://scenes/effects/SmallExplosion.tscn")

export(int) var radius = 20
export(int) var damage = 100

onready var collisionShape = $CollisionShape2D

var screensize: Vector2
var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	screensize = get_viewport_rect().size

func set_initial_velocity(vel: Vector2) -> void:
	velocity = vel

func _physics_process(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	velocity.y += GameData.GRAVITY * delta
	if collision:
		var body: Object = collision.get_collider()
		if body.is_in_group("walls"): 
			if GameData.game_settings["CurrentWalls"] == "Bounce":
				velocity = velocity.bounce(collision.normal)
#			if GameData.game_settings["CurrentWalls"] == "Static":
#				spawn_explosion()
#				bullet_finsihed()
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
		yield(spawn_explosion(), "completed")
		body.current_health -= damage
	
	bullet_finsihed()


func adjust_wrap_on_terrian_collison() -> void:
	if self.global_position.x >= screensize.x:
		self.global_position.x = 0
		return
	if self.global_position.x <= 0:
		self.global_position.x = screensize.x


func spawn_explosion() -> void:
	var explosion = SMALL_EXPLOSION.instance()
	explosion.global_position = self.global_position
	get_parent().add_child(explosion)
	yield(explosion, "animation_finished")
	

func bullet_finsihed() -> void:
	emit_signal("bullet_finished")
	self.queue_free()
	
