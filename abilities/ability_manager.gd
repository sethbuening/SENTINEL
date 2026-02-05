extends Node

var abilities: Dictionary

func _init():
	var ability_data = Util.load_json_data(Util.PATH_ABILITY_JSON)
	for i in ability_data.size():
		parse_ability_json(i, ability_data[str(i)])
		
func parse_ability_json(id: int, json_data: Dictionary):
	var ability_data: AbilityData = AbilityData.new()
	
	if Util.ABILITY_TYPES.get(json_data["ABILITY_TYPE"]) == null:
		push_warning("Received a null value from AbilityData.json!")
		return
	
	ability_data.ability_type = Util.ABILITY_TYPES.get(json_data["ABILITY_TYPE"])
	ability_data.ability_sub_type = Util.ABILITY_SUB_TYPES.get(json_data["ABILITY_SUB_TYPE"])
	ability_data.damage = int(json_data["DAMAGE"])
	ability_data.gain_gold = int(json_data["GAIN_GOLD"])
	ability_data.gain_silver = int(json_data["GAIN_SILVER"])
	
	abilities[ability_data.ability_type] = ability_data
