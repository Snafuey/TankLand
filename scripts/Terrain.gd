extends Node

export var displacement = 180
export var iterations = 7
export var height = 270
export (float) var smooth = 1

onready var terrainLine = $TerrainLine
onready var terrainPoly = $TerrainLine/TerrainPolygon
onready var terrainCollision = $DestructibleTerrain
onready var destructibleCollision = get_node("DestructibleTerrain/CollisionPolygon2D")

var screensize: Vector2
var current_displacement: float
var earth_color: Color

func _ready() -> void:
	randomize()
	screensize = get_viewport().get_visible_rect().size
	terrainLine.default_color = Color(0, 0, 0, 0)
	init_new_terrain()


func init_new_terrain() -> void:
	terrainLine.points = PoolVector2Array()
	set_start_end_line_points()
	for _i in range(iterations):
		add_line_points()
	var build_points: Array = get_build_points_array()
	build_terrain(build_points)

func set_start_end_line_points() -> void:
	current_displacement = displacement
	var start = Vector2(0, clamp(rand_range(height - displacement, 
			height + displacement), 10, screensize.y - 10))
	var end = Vector2(screensize.x, clamp(rand_range(height - displacement, 
			height + displacement), 10, screensize.y - 10))
	terrainLine.add_point(start)
	terrainLine.add_point(end)

func add_line_points() -> void:
	var old_points = terrainLine.points
	terrainLine.points = PoolVector2Array()
	for i in range(old_points.size() - 1):
		var midpoint = (old_points[i] + old_points[i+1]) / 2
		midpoint.y += current_displacement * pow(-1.0, randi() % 2)
		if midpoint.y <= 79:
			midpoint.y = 80
		elif midpoint.y >= 531:
			midpoint.y  = 530
		terrainLine.add_point(old_points[i])
		terrainLine.add_point(midpoint)
	terrainLine.add_point(old_points[old_points.size() - 1])
	current_displacement *= pow(2.0, -smooth)

func get_build_points_array() -> Array:
	var final_points: Array = terrainLine.points
	var bottom_left_point: Vector2 = Vector2(0, screensize.y)
	var bottom_right_point: Vector2 = Vector2(screensize.x, screensize.y)
	final_points.append(bottom_right_point)
	final_points.append(bottom_left_point)
	return final_points


func build_terrain(build_points: Array) -> void:
	set_terrian_color()
	terrainPoly.polygon = build_points
	destructibleCollision.polygon = build_points
	Events.emit_signal("terrain_finished", build_points)


func set_terrian_color() -> void:
	earth_color = Utils.get_random_terrian_color()
	terrainPoly.color = earth_color


func destroy_terrain(bullet_pos: Vector2, radius: int) -> void:
	build_new_polygons(bullet_pos, radius, terrainLine)
	build_new_polygons(bullet_pos, radius, terrainCollision)

func build_new_polygons(bullet_pos: Vector2, radius: int, type: Node) -> void:
	var numCirclePoints = 40
	var pointsArc = PoolVector2Array()
	pointsArc.push_back(bullet_pos)

	for i in range(numCirclePoints + 1):
		var anglePoint = deg2rad(i * 360 / numCirclePoints)
		pointsArc.push_back(bullet_pos + Vector2(cos(anglePoint), sin(anglePoint)) * radius)

	for poly in type.get_children():
		var clippedPolygons = Geometry.clip_polygons_2d(poly.polygon, pointsArc)
		if clippedPolygons.size() == 0:
			poly.queue_free()
				
		for i in range(clippedPolygons.size()):
			var clippedPolygon = clippedPolygons[i]
			if clippedPolygon.size() < 3:
				continue

			var newPoints = PoolVector2Array()
			for point in clippedPolygon:
				newPoints.push_back(point)

			if i == 0:
				poly.call_deferred("set", "polygon", newPoints)
			else:
				if type is Line2D:
					var newPoly: Polygon2D = Polygon2D.new()
					newPoly.polygon = newPoints
					newPoly.color = earth_color
					type.call_deferred("add_child", newPoly)
				elif type is StaticBody2D:
					var collider: CollisionPolygon2D = CollisionPolygon2D.new()
					collider.polygon = newPoints
					type.call_deferred("add_child", collider)


func _input(event) -> void:
	if Utils.DEBUG_MODE:
		if event.is_action_released("mouse_btn_left"):
			get_tree().set_input_as_handled()
			init_new_terrain()
		if event.is_action_released("mouse_btn_right"):
			var mouse_position: Vector2 = get_viewport().get_mouse_position()
			destroy_terrain(mouse_position, 20)
