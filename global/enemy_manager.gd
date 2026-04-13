extends Node

## Spawns different enemy types each turn

@export var map_center: Vector2 = Vector2.ZERO
@export var spawn_radius: float = 1000
@export var spawn_delay: float = 0.0

var enemies_complete: int = 0
var enemy_scene: PackedScene = preload("res://scenes/Enemy.tscn")
var enemies: Array[Enemy] = []

@export_group("Enemy Types")
## Define all enemy types once - referenced by ID
var enemy_resources: Dictionary = {
	Util.ENEMY_TYPES.SIEGE_TANK: preload("res://resources/enemies/siege_tank.tres"),
	Util.ENEMY_TYPES.ANGEL: preload("res://resources/enemies/angel.tres")
}

@export_group("Turn Spawns")
## Define what spawns each turn
var turn1: TurnSpawnData = TurnSpawnData.new([EnemyTypeCountData.new(Util.ENEMY_TYPES.SIEGE_TANK, 3), EnemyTypeCountData.new(Util.ENEMY_TYPES.ANGEL, 1)])
var turn2: TurnSpawnData = TurnSpawnData.new([EnemyTypeCountData.new(Util.ENEMY_TYPES.SIEGE_TANK, 4)])
var turn3: TurnSpawnData = TurnSpawnData.new([EnemyTypeCountData.new(Util.ENEMY_TYPES.SIEGE_TANK, 5)])
var turn4: TurnSpawnData = TurnSpawnData.new([EnemyTypeCountData.new(Util.ENEMY_TYPES.SIEGE_TANK, 6)])
var turn5: TurnSpawnData = TurnSpawnData.new([EnemyTypeCountData.new(Util.ENEMY_TYPES.SIEGE_TANK, 7)])
var turn6: TurnSpawnData = TurnSpawnData.new([EnemyTypeCountData.new(Util.ENEMY_TYPES.SIEGE_TANK, 8)])
var turn7: TurnSpawnData = TurnSpawnData.new([EnemyTypeCountData.new(Util.ENEMY_TYPES.SIEGE_TANK, 9)])
@export var turn_spawns: Array[TurnSpawnData] = [turn1, turn2, turn3, turn4, turn5, turn6, turn7]

signal enemies_turn_end

func _ready() -> void:
	GameManager.enemy_turn_started.connect(_on_enemy_turn_started)

func _on_enemy_turn_started() -> void:
	var turn_index = GameManager.turn_number - 1  # 0-indexed
	enemies_complete = 0
	
	# spawn in enemies
	if turn_index < turn_spawns.size():
		var spawn_data: TurnSpawnData = turn_spawns[turn_index]
		spawn_turn(spawn_data)
	else:
		print("[EnemyManager] All scheduled spawns complete")
	
	# start each enemy's turn
	for e in get_children():
		e.start_turn()


func spawn_turn(spawn_data: TurnSpawnData) -> void:
	print("[EnemyManager] Turn %d: Spawning enemies" % GameManager.turn_number)
	
	# Spawn each enemy type
	for enemy_type in spawn_data.enemy_types:
		for i in enemy_type.count:
			if spawn_delay > 0:
				await get_tree().create_timer(spawn_delay).timeout
			spawn_enemy(enemy_type.type)


func spawn_enemy(type: Util.ENEMY_TYPES) -> void:
	if not enemy_scene:
		return
	
	var enemy = enemy_scene.instantiate()
	enemy.enemy_r = enemy_resources[type]
	add_child(enemy)
	enemies.append(enemy)
	enemy.turn_complete.connect(update_completion)
	
	# Spawn at random position around the circle
	var angle = randf() * TAU
	var pos = map_center + Vector2(cos(angle), sin(angle)) * spawn_radius
	enemy.global_position = pos

func update_completion():
	enemies_complete += 1
	print("[EnemyManager] " + str(get_children().size() - enemies_complete) + " enemies still need to finish their turn!")
	if enemies_complete >= get_children().size():
		enemies_turn_end.emit()
