extends Resource
class_name Behavior

var type: Util.ENEMY_TYPES
var enemy: Enemy
var value_1: float
var value_2: float
var value_3: float

func setup(e: Enemy):
	enemy = e
	value_1 = DataManager.enemies[type].value_1
	value_2 = DataManager.enemies[type].value_2
	value_3 = DataManager.enemies[type].value_3
