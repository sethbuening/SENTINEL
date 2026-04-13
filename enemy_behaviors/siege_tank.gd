extends Behavior
class_name Siege_Tank

func setup(e: Enemy) -> void:
	type = Util.ENEMY_TYPES.SIEGE_TANK
	super.setup(e)

func start_turn():
	if enemy.dying:
		enemy.turn_complete.emit()
		return
	var closest_tower: tower
	var closest_distance: float = INF
	for t in Singleton.game.get_children():
		if t is tower:
			t = t as tower
			var distance: float = t.global_position.distance_to(enemy.global_position)
			if distance < closest_distance:
				closest_tower = t
				closest_distance = distance
	if (closest_distance >= 200):
		enemy.velocity = enemy.global_position.direction_to(closest_tower.global_position) * enemy.speed
		enemy.get_tree().create_timer(2).timeout.connect(func():
			enemy.velocity = Vector2.ZERO
			if (closest_distance < 200):
				if closest_tower:
					closest_tower.take_damage(3)
			enemy.turn_complete.emit()
		)
	else:
		if (closest_distance < 200):
			if closest_tower:
				closest_tower.take_damage(floor(value_1 * closest_tower.health_bar.MAX_HEALTH / 100))
		enemy.turn_complete.emit()
