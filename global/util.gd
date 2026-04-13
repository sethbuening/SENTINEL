extends Node

var PATH_TOWER_JSON: String = "res://data/Eclipse Data - Towers.json"
var PATH_ABILITY_JSON: String = "res://data/Eclipse Data - Abilities.json"
var PATH_ENEMY_JSON: String = "res://data/Eclipse Data - Enemies.json"

enum TOWER_TYPES {
	TOWER_1,
	TOWER_2,
	TOWER_3
}

enum TOWER_SUB_TYPES {
	ATTACK,
	ECONOMY,
	DEFENSE
}

enum RARITY {
	COMMON,
	UNCOMMON,
	RARE,
	EPIC,
	MYTHIC,
	LEGENDARY
}

enum ABILITY_TYPES {
	CHARGE_SHOT,
	MAJOR_SILVER,
	BOLSTER,
	MINOR_SILVER,
	BOLSTER_LESSER,
	CHARGE
}

enum ABILITY_SUB_TYPES {
	ATTACK,
	DEFENSE,
	SPECIAL
}

enum ENEMY_TYPES {
	SIEGE_TANK,
	ARCHER,
	ANGEL,
	DAGGER,
	SHIELD_MAGE
}

enum ENEMY_SUB_TYPES {
	MELEE,
	RANGED,
	SPECIAL
}

func load_json_data(path: String):
	var file_string = FileAccess.get_file_as_string(path)
	var json_data
	if file_string != null:
		json_data = JSON.parse_string(file_string)
	else:
		push_warning("load_json_data failed get_file_as_string for path: ", path)
	
	if json_data == null:
		push_error("load_json_data failed to parse file data to JSON for path: ", path)
		
	return json_data

func to_8_direction(dir: Vector2) -> Vector2:
	if dir == Vector2.ZERO:
		return Vector2.ZERO

	dir = dir.normalized()

	var x: int = sign(dir.x)
	var y: int = sign(dir.y)

	# Angle thresholds for diagonals (22.5° and 67.5°)
	if abs(dir.x) < 0.382683: # sin(22.5°)
		x = 0
	elif abs(dir.y) < 0.382683:
		y = 0

	return Vector2(x, y)
	
func move(n: CharacterBody2D, move_speed: float, loc: Vector2) -> void:
	var moved_distance: float = 0
	while (moved_distance < move_speed and n.position.distance_squared_to(loc) > 0):
		if (moved_distance == 0):
			n.velocity = to_8_direction(n.position.direction_to(loc)) * (move_speed / 2)
		pass
	n.velocity = Vector2.ZERO
