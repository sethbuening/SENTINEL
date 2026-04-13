extends Ability
class_name Charge_Shot

var damage: int = DataManager.abilities[type].damage

func setup(t_: tower):
	type = Util.ABILITY_TYPES.CHARGE_SHOT
	super.setup(t_)

func cast():
	if t.tower_resource.secondary.charge < 2:
		print("[CHARGE_SHOT.gd] Not enough charges!")
		return

	var valid_enemies: Array[Enemy] = []

	for e in EnemyManager.get_children():
		if e is Enemy and not e.dying:
			valid_enemies.append(e)

	if valid_enemies.is_empty():
		print("[CHARGE_SHOT.gd] No valid enemies")
		return

	var enemy: Enemy = valid_enemies[0]
	var min_dist := enemy.global_position.distance_to(t.global_position)

	for i in range(1, valid_enemies.size()):
		var dist := valid_enemies[i].global_position.distance_to(t.global_position)
		if dist < min_dist:
			enemy = valid_enemies[i]
			min_dist = dist
	
	if min_dist > range:
		print(min_dist)
		return
	
	print("[CHARGE_SHOT.gd] Damaging an enemy")
	enemy.take_damage(damage + t.tower_resource.secondary.charge - 2)
	t.tower_resource.secondary.charge = 0
