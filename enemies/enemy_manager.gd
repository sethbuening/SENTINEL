extends Node

var enemies: Dictionary

func _init():
	var enemy_data = Util.load_json_data(Util.PATH_ENEMY_JSON)
	for i in enemy_data.size():
		parse_enemy_json(i, enemy_data[str(i)])
		
func parse_enemy_json(id: int, json_data: Dictionary):
	var enemy_data: EnemyData = EnemyData.new()
	
	if Util.ENEMY_TYPES.get(json_data["ENEMY_TYPE"]) == null:
		push_warning("Received a null value from EnemyData.json!")
		return
	
	enemy_data.enemy_type = Util.ENEMY_TYPES.get(json_data["ENEMY_TYPE"])
	enemy_data.enemy_sub_type = Util.ENEMY_SUB_TYPES.get(json_data["ENEMY_SUB_TYPE"])
	enemy_data.wave_cost = int(json_data["WAVE_COST"])
	
	enemies[enemy_data.enemy_type] = enemy_data
