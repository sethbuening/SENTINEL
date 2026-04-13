extends Node

var enemies: Dictionary
var towers: Dictionary
var abilities: Dictionary

func _init():
	var enemy_data = Util.load_json_data(Util.PATH_ENEMY_JSON)
	var tower_data = Util.load_json_data(Util.PATH_TOWER_JSON)
	var ability_data = Util.load_json_data(Util.PATH_ABILITY_JSON)
	
	for i in enemy_data.size():
		parse_enemy_json(i, enemy_data[str(i)])
	for i in tower_data.size():
		parse_tower_json(i, tower_data[str(i)])
	for i in ability_data.size():
		parse_ability_json(i, ability_data[str(i)])

func parse_enemy_json(id: int, json_data: Dictionary):
	var enemy_data: EnemyData = EnemyData.new()
	
	if Util.ENEMY_TYPES.get(json_data["ENEMY_TYPE"]) == null:
		push_warning("Received a null value on id %d from EnemyData.json!" % id)
		return
	
	enemy_data.enemy_type = Util.ENEMY_TYPES.get(json_data["ENEMY_TYPE"])
	enemy_data.enemy_sub_type = Util.ENEMY_SUB_TYPES.get(json_data["ENEMY_SUB_TYPE"])
	enemy_data.max_health = int(json_data["MAX_HEALTH"])
	enemy_data.wave_cost = int(json_data["WAVE_COST"])
	enemy_data.speed = float(json_data["SPEED"])
	enemy_data.value_1 = float(json_data["1"])
	enemy_data.value_2 = float(json_data["2"])
	enemy_data.value_3 = float(json_data["3"])
	
	enemies[enemy_data.enemy_type] = enemy_data

func parse_tower_json(id: int, json_data: Dictionary):
	var tower_data: TowerData = TowerData.new()
	
	if Util.TOWER_TYPES.get(json_data["TOWER_TYPE"]) == null:
		push_warning("Received a null value on id %d from TowerData.json!" % id)
		return
	
	tower_data.tower_type = Util.TOWER_TYPES.get(json_data["TOWER_TYPE"])
	tower_data.tower_sub_type = Util.TOWER_SUB_TYPES.get(json_data["TOWER_SUB_TYPE"])
	tower_data.max_health = int(json_data["MAX_HEALTH"])
	tower_data.cost_gold = int(json_data["COST_GOLD"])
	tower_data.cost_silver = int(json_data["COST_SILVER"])
	tower_data.rarity = Util.RARITY.get(json_data["RARITY"])
	
	towers[tower_data.tower_type] = tower_data

func parse_ability_json(id: int, json_data: Dictionary):
	var ability_data: AbilityData = AbilityData.new()
	
	if Util.ABILITY_TYPES.get(json_data["ABILITY_TYPE"]) == null:
		push_warning("Received a null value on id %d from AbilityData.json!" % id)
		return
	
	ability_data.ability_type = Util.ABILITY_TYPES.get(json_data["ABILITY_TYPE"])
	ability_data.ability_sub_type = Util.ABILITY_SUB_TYPES.get(json_data["ABILITY_SUB_TYPE"])
	ability_data.damage = int(json_data["DAMAGE"])
	ability_data.gain_gold = int(json_data["GAIN_GOLD"])
	ability_data.gain_silver = int(json_data["GAIN_SILVER"])
	ability_data.gain_health = int(json_data["GAIN_HEALTH"])
	ability_data.range = float(json_data["RANGE"])
	ability_data.name = json_data["NAME"]
	ability_data.description = json_data["DESCRIPTION"]
	
	abilities[ability_data.ability_type] = ability_data
