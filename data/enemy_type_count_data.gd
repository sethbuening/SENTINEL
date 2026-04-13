extends Resource
class_name EnemyTypeCountData

## How many of a specific enemy type to spawn
var type: Util.ENEMY_TYPES
var count: int = 1

func _init(t: Util.ENEMY_TYPES, c: int) -> void:
	type = t
	count = c
