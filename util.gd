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
	ABILITY_1,
	ABILITY_2,
	ABILITY_3
}

enum ABILITY_SUB_TYPES {
	ATTACK,
	ECONOMY,
	DEFENSE
}

enum ENEMY_TYPES {
	ENEMY_1,
	ENEMY_2,
	HEALER
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
