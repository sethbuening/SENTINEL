extends Resource
class_name Ability

var type: Util.ABILITY_TYPES

func cast():
	print("Cast " + Util.ABILITY_TYPES.keys()[type] + "!")
