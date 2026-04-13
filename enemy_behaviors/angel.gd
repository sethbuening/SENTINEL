extends Behavior
class_name Angel

func setup(e: Enemy) -> void:
	type = Util.ENEMY_TYPES.ANGEL
	super.setup(e)

func start_turn():
	if enemy.dying:
		enemy.turn_complete.emit()
		return
	# move to maximize the amount of healing done
	Util.move(enemy, enemy.move_speed, find_best_heal_position(EnemyManager.enemies)["position"])

	# for all creatures in range, heal for value_1 amount of health
	for e in EnemyManager.enemies:
		if enemy.position.distance_to(e.position) < value_2:
			e.health_bar.current_health += 5
	
	enemy.turn_complete.emit()

func find_best_heal_position(enemies: Array) -> Dictionary:
	var healer_pos: Vector2 = enemy.global_position
	var move_range_sq := enemy.move_speed * enemy.move_speed
	var heal_radius_sq := value_1 * value_1
	
	# Step 1: Filter enemies that are impossible to heal this turn
	var filtered: Array = []
	for e in enemies:
		var dist_sq := healer_pos.distance_squared_to(e.global_position)
		if dist_sq <= (enemy.move_speed + value_2) * (enemy.move_speed + value_2):
			filtered.append(e)
	
	var best_count := 0
	var best_position := healer_pos
	
	# Always check current position
	if _is_position_valid(healer_pos, enemies):
		best_count = _count_enemies_in_radius(healer_pos, heal_radius_sq, enemies)
	
	# Step 2: Check all enemy pairs
	for i in range(filtered.size()):
		for j in range(i + 1, filtered.size()):
			
			var A: Vector2 = filtered[i].global_position
			var B: Vector2 = filtered[j].global_position
			
			var centers = get_circle_centers(A, B, value_2)
			
			for C in centers:
				
				# Movement constraint
				if healer_pos.distance_squared_to(C) > move_range_sq:
					continue
				
				# Collision constraint
				if not _is_position_valid(C, enemies):
					continue
				
				var count := _count_enemies_in_radius(C, heal_radius_sq, enemies)
				
				if count > best_count:
					best_count = count
					best_position = C
	
	return {
		"position": best_position,
		"count": best_count
	}

func _is_position_valid(pos: Vector2, enemies: Array) -> bool:
	
	for e in enemies:
		e = e as Enemy
		var min_dist_sq : float = (enemy.collider.shape.radius + e.collider.shape.radius) ** 2
		if pos.distance_squared_to(e.global_position) < min_dist_sq:
			return false
	
	return true


func _count_enemies_in_radius(center: Vector2, radius_sq: float, enemies: Array) -> int:
	var count := 0
	
	for e in enemies:
		if center.distance_squared_to(e.global_position) <= radius_sq:
			count += 1
	
	return count

func get_circle_centers(A: Vector2, B: Vector2, R: float) -> Array:
	var centers := []

	var AB := B - A
	var d_sq := AB.length_squared()
	var R2 := R * R

	# If points are identical or too far apart, no valid circle
	if d_sq == 0.0 or d_sq > 4.0 * R2:
		return centers

	var mid := (A + B) * 0.5
	var h := sqrt(R2 - d_sq * 0.25)

	var dir := AB.normalized()
	var perp := Vector2(-dir.y, dir.x)

	centers.append(mid + perp * h)
	centers.append(mid - perp * h)

	return centers
