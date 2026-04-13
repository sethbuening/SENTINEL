extends Resource
class_name Ability

var type: Util.ABILITY_TYPES
var t: tower
@warning_ignore("shadowed_global_identifier")
var range: float = 0
var name: String
var description: String

func setup(t_: tower):
	t = t_
	range = DataManager.abilities[type].range
	name = DataManager.abilities[type].name
	description = DataManager.abilities[type].description

func cast():
	print("Cast " + Util.ABILITY_TYPES.keys()[type] + "!")
