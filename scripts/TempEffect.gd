extends AnimatedSprite

func _ready() -> void:	
	self.frame = 0
	self.play("animate")
	$SFXExplosion.playing = true	
	
func _on_animation_finished() -> void:
	self.queue_free()
