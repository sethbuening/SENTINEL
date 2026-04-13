extends CharacterBody2D
class_name Enemy

@export var enemy_r: enemy_r

@warning_ignore("shadowed_global_identifier")
var effects: Dictionary = {} # the amount of each effect applied to this creature

var type: Util.ENEMY_TYPES
var health_bar: HealthBar
var sprite: Sprite2D
var speed: float
var dying: bool
var move_speed: float
@onready var collider: CollisionShape2D = get_node("CollisionShape2D")

signal turn_complete

func _ready() -> void:
	type = enemy_r.type
	
	enemy_r = enemy_r.duplicate()
	enemy_r.behavior = enemy_r.behavior.duplicate()
	enemy_r.behavior.setup(self)
	
	health_bar = get_node("HealthBar")
	health_bar.MAX_HEALTH = DataManager.enemies[type].max_health
	health_bar.current_health = health_bar.MAX_HEALTH
	
	sprite = get_node("Sprite2D")
	sprite.texture = enemy_r.sprite
	speed = DataManager.enemies[type].speed

func _process(delta: float) -> void:
	move_and_slide()

func start_turn():
	enemy_r.behavior.start_turn()

func take_damage(amount: int) -> void:
	if health_bar:
		health_bar.take_damage(amount)
	else:
		print("[enemy.gd] Could not find a health bar to take damage!")

func die():
	print("[EnemyManager] 1 enemy killed!")
	dying = true
	EnemyManager.enemies.erase(self)
	# 0.9 is how long until the healthbar has fully hit zero
	get_tree().create_timer(0.9).timeout.connect(func():
		queue_free()
	)
