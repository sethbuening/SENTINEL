extends Node

var towers: Dictionary

func _init():
	var tower_data = Util.load_json_data(Util.PATH_TOWER_JSON)
	for i in tower_data.size():
		parse_tower_json(i, tower_data[str(i)])
		
func parse_tower_json(id: int, json_data: Dictionary):
	var tower_data: TowerData = TowerData.new()
	
	if Util.TOWER_TYPES.get(json_data["TOWER_TYPE"]) == null:
		push_warning("Received a null value from TowerData.json!")
		return
	
	tower_data.tower_type = Util.TOWER_TYPES.get(json_data["TOWER_TYPE"])
	tower_data.tower_sub_type = Util.TOWER_SUB_TYPES.get(json_data["TOWER_SUB_TYPE"])
	tower_data.max_health = int(json_data["MAX_HEALTH"])
	tower_data.cost_gold = int(json_data["COST_GOLD"])
	tower_data.cost_silver = int(json_data["COST_SILVER"])
	tower_data.rarity = Util.RARITY.get(json_data["RARITY"])
	
	towers[tower_data.tower_type] = tower_data
