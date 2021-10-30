extends Area2D

signal explosion_hit_tank(tank_ref, damage_value) # warning-ignore:unused_signal
signal explosion_finished() # warning-ignore:unused_signal

onready var collisionShape = $CollisionShape2D
onready var sprite = $Sprite
onready var animPlayer = $AnimationPlayer
onready var tween = $Tween
onready var SFXPlayer = $SFXAudioStream
onready var turnQueue = get_parent().get_node("TurnQueue")

func _ready() -> void:
	var err: int = connect("explosion_finished", turnQueue, "set_next_turn")
	if err:
		printerr("Connection Failed " + str(err))
	err = connect("explosion_hit_tank", turnQueue, "append_damage_queue")
	if err:
		printerr("Connection Failed " + str(err))
	animPlayer.play("explosion")
	SFXPlayer.playing = true
	

func _on_Explosion_body_entered(body: Node) -> void:
	if body.is_in_group("tank"):
		# warning-ignore:narrowing_conversion
		var damage: int = round(calculate_damage(body)) 
		emit_signal("explosion_hit_tank", body, damage )


func calculate_damage(tank: KinematicBody2D) -> float:
	var distance_from_center: float = self.global_position.distance_to(tank.global_position)
	var shape: CircleShape2D = collisionShape.shape
	var damage_percentage: float = (distance_from_center / shape.radius) * 100
	if damage_percentage < 1:
		damage_percentage = 1
	var damage: float = 100 - damage_percentage
	return damage


func _on_animation_finished(_anim_name: String) -> void:
	emit_signal("explosion_finished")
	self.queue_free()

