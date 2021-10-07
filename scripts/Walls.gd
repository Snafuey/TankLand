extends Node

onready var line: Line2D = $IndicatorLine
onready var leftWall: CollisionShape2D = $Left/CollisionShape2D
onready var rightWall: CollisionShape2D = $Right/CollisionShape2D
onready var topWall: CollisionShape2D = $Top/CollisionShape2D
onready var bottomWall: CollisionShape2D = $Bottom/CollisionShape2D

func _ready() -> void:
	var battleMain: Node = get_parent()
	battleMain.connect("walls_changed", self, "set_walls") # warning-ignore:return_value_discarded


func get_random_wall_type() -> String:
	randomize()
	var walls_list: Array = GameData.game_settings["Walls"]
	walls_list.erase("Random")
	var rand_index: int = round(rand_range(0 , walls_list.size()))# warning-ignore:narrowing_conversion
	var rand_wall: String = walls_list[rand_index]
	return rand_wall


func set_walls(type: String) -> void:
	match type:
		"Static":
			line.default_color = Color.blue
			leftWall.set_deferred("disabled", false)
			rightWall.set_deferred("disabled", false)
			topWall.set_deferred("disabled", false)
			bottomWall.set_deferred("disabled", false)
		"Bounce":
			line.default_color = Color.red
			leftWall.set_deferred("disabled", false)
			rightWall.set_deferred("disabled", false)
			topWall.set_deferred("disabled", false)
			bottomWall.set_deferred("disabled", false)
		"Wrap":
			line.default_color = Color.fuchsia
			leftWall.set_deferred("disabled", true)
			rightWall.set_deferred("disabled", true)
			topWall.set_deferred("disabled", true)
			bottomWall.set_deferred("disabled", true)
		"Random":
			var rand_wall: String = get_random_wall_type()
			set_walls(rand_wall)
