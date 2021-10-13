extends KinematicBody2D

signal bullet_finished()

const SMALL_EXPLOSION = preload("res://scenes/effects/SmallExplosion.tscn")

export(int) var radius = 20
export(int) var damage = 100

var screensize: Vector2
var velocity: Vector2 = Vector2.ZERO
var speed: int

func _ready() -> void:
	screensize = get_viewport_rect().size

func init_projectile(vel: Vector2) -> void:
	velocity = vel

func _physics_process(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	velocity.y += GameData.GRAVITY * delta
	if collision:
		var body = collision.get_collider()
		if body.is_in_group("walls"): 
			if GameData.game_settings["CurrentWalls"] == "Bounce":
				velocity = velocity.bounce(collision.normal)
			if GameData.game_settings["CurrentWalls"] == "Static":
				spawn_explosion()
				bullet_finsihed()
		
		if body.is_in_group("terrainCollision"):
			spawn_explosion()
			body.get_parent().destroy_terrain(self.global_position, radius)
			bullet_finsihed()
		
		if body.is_in_group("tank"):
			spawn_explosion()
			body.current_health -= damage
			bullet_finsihed()
	
	if self.global_position.x > screensize.x:
		self.global_position.x = 0
	if self.global_position.x < 0.0:
		self.global_position.x = screensize.x
	
			
func spawn_explosion() -> void:
	var explosion = SMALL_EXPLOSION.instance()
	explosion.global_position = self.global_position
	get_parent().add_child(explosion)
	

func bullet_finsihed() -> void:
	emit_signal("bullet_finished")
	self.queue_free()
	
