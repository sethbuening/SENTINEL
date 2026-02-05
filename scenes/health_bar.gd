extends Node2D

@onready var orange_bar: TextureProgressBar = get_node("OrangeBar")
@onready var red_bar: TextureProgressBar = get_node("RedBar")

@onready var parent: Node = get_parent()

@export var MAX_HEALTH: int = 3
var current_health: int = MAX_HEALTH

@export var sprite: Sprite2D = null

func _ready() -> void:
	visible = false
	
	red_bar.max_value = MAX_HEALTH
	red_bar.value = current_health
	orange_bar.max_value = MAX_HEALTH * 100
	orange_bar.value = MAX_HEALTH * 100
	
	# start flashing the orange bar
	$AnimationPlayer.play("flashing_orange_bar")

func take_damage(amount: int) -> void:
	if not visible:
		visible = true
	
	current_health -= amount
	
	# change health bars
	red_bar.value = current_health
	
	# die or flash brighter when taking damage
	if current_health <= 0:
		current_health = 0
		die()
	else:
		# tween the orange progress bar to the red one
		get_tree().create_timer(0.6).timeout.connect(func():
			var tween := create_tween()
			tween.tween_property(orange_bar, "value", current_health * 100, 0.3)
		)
		
		# flash enemies when they take damage
		'''if sprite != null:
			sprite.material.set_shader_parameter("flash_strength", 0.5)
			Singleton.game.get_tree().create_timer(0.3).timeout.connect(func():
				sprite.material.set_shader_parameter("flash_strength", 0.0)
			)'''

func die() -> void:
	parent.movement_enabled = false
	EnemyManager.enemies.erase(parent)
	
	get_tree().create_timer(0.6).timeout.connect(func():
		var tween := create_tween()
		tween.tween_property(orange_bar, "value", current_health * 100, 0.3)
		get_tree().create_timer(0.3).timeout.connect(func():
			parent.queue_free()
		)
	)
