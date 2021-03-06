extends Node

onready var line: Line2D = $IndicatorLine
onready var leftWall: CollisionShape2D = $Left/CollisionShape2D
onready var rightWall: CollisionShape2D = $Right/CollisionShape2D
onready var topWall: CollisionShape2D = $Top/CollisionShape2D
onready var bottomWall: CollisionShape2D = $Bottom/CollisionShape2D

func _ready() -> void:
	var err: int = Events.connect("battleMain_walls_changed", self, "set_walls")
	if err:
		print_debug("Connection Failed")

func set_walls(type: String) -> void:
	match type:
		"Static":
			line.default_color = Color.blue
			leftWall.set_deferred("disabled", false)
			rightWall.set_deferred("disabled", false)
			topWall.set_deferred("disabled", false)
		"Bounce":
			line.default_color = Color.red
			leftWall.set_deferred("disabled", false)
			rightWall.set_deferred("disabled", false)
			topWall.set_deferred("disabled", false)
		"Wrap":
			line.default_color = Color.fuchsia
			leftWall.set_deferred("disabled", true)
			rightWall.set_deferred("disabled", true)
			topWall.set_deferred("disabled", true)
		"Random":
			set_walls(Utils.get_random_wall_type())
