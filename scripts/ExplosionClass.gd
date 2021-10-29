extends Area2D

onready var collisionShape = $CollisionShape2D
onready var sprite = $Sprite
onready var animPlayer = $AnimationPlayer
onready var tween = $Tween
onready var SFXPlayer = $SFXAudioStream


func _ready() -> void:
	animPlayer.play("explosion")
	SFXPlayer.playing = true
	

func _on_Explosion_body_entered(body: Node) -> void:
	if body.is_in_group("tank"):
		# warning-ignore:narrowing_conversion
		var damage: int = round(calculate_damage(body)) 
		Events.emit_signal("explosion_hit_tank", body, damage )


func calculate_damage(tank: KinematicBody2D) -> float:
	var origin_distance: float = self.global_position.distance_to(tank.global_position)
	var shape: CircleShape2D = collisionShape.shape
	var damage: float = (shape.radius / origin_distance) * 10
	return damage


func _on_animation_finished(_anim_name: String) -> void:
	Events.emit_signal("explosion_finished")
	self.queue_free()

