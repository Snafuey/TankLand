extends StaticBody2D


func destroy_terrain(bullet_pos: Vector2, radius: int) -> void:
	var numCirclePoints = 40
	var pointsArc = PoolVector2Array()
	pointsArc.push_back(bullet_pos)
	
	for i in range(numCirclePoints + 1):
		var anglePoint = deg2rad(i * 360 / numCirclePoints)
		pointsArc.push_back(bullet_pos + Vector2(cos(anglePoint), sin(anglePoint)) * radius)
	
	for collisionPoly in self.get_children():
		var clippedPolygons = Geometry.clip_polygons_2d(collisionPoly.polygon, pointsArc)
		if clippedPolygons.size() == 0:
			collisionPoly.queue_free()
			
		for i in range(clippedPolygons.size()):
			var clippedCollision = clippedPolygons[i]
			if clippedCollision.size() < 3:
				continue

			var newPoints = PoolVector2Array()
			for point in clippedCollision:
				newPoints.push_back(point)

			if i == 0:
				collisionPoly.call_deferred("set", "polygon", newPoints)
			else:
				var collider: CollisionPolygon2D = CollisionPolygon2D.new()
				collider.polygon = newPoints
				self.call_deferred("add_child", collider)
