extends Node

signal set_spawn_points(value)

export var displacement = 180
export var iterations = 7
export var height = 270
export (float) var smooth = 1

onready var terrainLine = $TerrainLine
onready var terrainPoly = $TerrainLine/TerrainPolygon
onready var destructibleCollision = get_node("DestructibleTerrain/CollisionPolygon2D")

var screensize: Vector2
var current_displacement: float
var earth_color: Color = Color.aliceblue

func _ready() -> void:
	self.set_name("Terrain")
	randomize()
	screensize = get_viewport().get_visible_rect().size
	init_line()


func init_line() -> void:
	current_displacement = displacement
	terrainLine.points = PoolVector2Array()
	var start = Vector2(0, clamp(rand_range(height - displacement, height + displacement), 
											10, screensize.y - 10))
	var end = Vector2(screensize.x, clamp(rand_range(height - displacement, height + displacement),
											10, screensize.y - 10))
	terrainLine.add_point(start)
	terrainLine.add_point(end)
	
	for _i in range(iterations):
		add_points()
	
	terrainLine.default_color = Color(0, 0, 0, 0)
	var p: Array = terrainLine.points
	set_terrain(p)


func add_points() -> void:
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


func set_terrain(p: Array) -> void:
	p.append(Vector2(screensize.x, screensize.y))
	p.append(Vector2(0, screensize.y))
	set_terrian_color()
	terrainPoly.polygon = p
	destructibleCollision.polygon = p
	var battleMain = get_parent()
	connect("set_spawn_points", battleMain, "set_tank_spawn_points") # warning-ignore:return_value_discarded
	emit_signal("set_spawn_points", p)


func set_terrian_color() -> void:
	var keys: Array = GameData.earth_colors.keys()
	earth_color = GameData.earth_colors[keys[randi() % keys.size()]]
	terrainPoly.color = earth_color


func destroy_terrain(bullet_pos: Vector2, radius: int) -> void:
	var numCirclePoints = 40
	var pointsArc = PoolVector2Array()
	pointsArc.push_back(bullet_pos)

	for i in range(numCirclePoints + 1):
		var anglePoint = deg2rad(i * 360 / numCirclePoints)
		pointsArc.push_back(bullet_pos + Vector2(cos(anglePoint), sin(anglePoint)) * radius)

	for Poly in terrainLine.get_children():
		var clippedPolygons = Geometry.clip_polygons_2d(Poly.polygon, pointsArc)
		if clippedPolygons.size() == 0:
			Poly.queue_free()

		for i in range(clippedPolygons.size()):
			var clippedPolygon = clippedPolygons[i]
			if clippedPolygon.size() < 3:
				continue

			var newPoints = PoolVector2Array()
			for point in clippedPolygon:
				newPoints.push_back(point)

			if i == 0:
				Poly.call_deferred("set", "polygon", newPoints)
			else:
				var newPoly: Polygon2D = Polygon2D.new()
				newPoly.polygon = newPoints
				newPoly.color = earth_color
				terrainLine.call_deferred("add_child", newPoly)


#USE FOR TESTING
#func _input(event) -> void:
#	if event is InputEventMouseButton and event.pressed:
#		init_line()
