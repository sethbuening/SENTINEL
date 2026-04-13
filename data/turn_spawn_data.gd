extends Resource
class_name TurnSpawnData

var enemy_types: Array[EnemyTypeCountData] = []

## Defines what enemies spawn on a specific turn
func _init(et: Array[EnemyTypeCountData]):
	enemy_types = et
