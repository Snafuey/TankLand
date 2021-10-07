class_name Bullet
extends RigidBody2D

signal bullet_finished()

const SMALL_EXPLOSION = preload("res://scenes/effects/SmallExplosion.tscn")

export var radius: int = 20
export var damage: int = 100

#onready var terrainPoly = get_parent().get_node("Terrain")

var screensize: Vector2

func _ready() -> void:
	screensize = get_viewport_rect().size


func _on_Bullet_body_entered(body: Node) -> void:
	if body.is_in_group("tank"):
		body.current_health -= damage
		spawn_explosion()
		bullet_finsihed()
	if body.is_in_group("terrainCollision"):
		var terrainPoly: Node = get_parent().get_node("Terrain")
		body.destroy_terrain(self.global_position, radius)
		terrainPoly.destroy_terrain(self.global_position, radius)
		spawn_explosion()
		bullet_finsihed()
	if body.is_in_group("walls"):
		if GameData.game_settings["CurrentWalls"] == "Bounce":
			return
		spawn_explosion()
		bullet_finsihed()


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	var xform = state.get_transform()
	if xform.origin.x > screensize.x:
		xform.origin.x = 0
	if xform.origin.x < 0:
		xform.origin.x = screensize.x
#	if xform.origin.y > screensize.y:
#		xform.origin.y = 40
#	if xform.origin.y < 40:
#		xform.origin.y = screensize.y
	state.set_transform(xform)


func spawn_explosion() -> void:
	var explosion = SMALL_EXPLOSION.instance()
	explosion.global_position = self.global_position
	get_parent().add_child(explosion)

func bullet_finsihed() -> void:
	emit_signal("bullet_finished")
	self.queue_free()
