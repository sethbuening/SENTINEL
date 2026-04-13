extends Node2D
class_name HealthBar

@onready var orange_bar: TextureProgressBar = get_node("OrangeBar")
@onready var red_bar: TextureProgressBar = get_node("RedBar")

@onready var parent: Node = get_parent()

var MAX_HEALTH: int = -1:
	set(value):
		MAX_HEALTH = value
		red_bar.max_value = value
		orange_bar.max_value = value * 100
		$NotchDrawer.set_max_health(value)
	get():
		return MAX_HEALTH

var current_health: int = -1:
	set(value):
		current_health = clamp(value, 0, MAX_HEALTH)
		red_bar.value = current_health
		
		# tween the orange progress bar to the red one
		get_tree().create_timer(0.6).timeout.connect(func():
			var tween := create_tween()
			tween.tween_property(orange_bar, "value", current_health * 100, 0.3)
		)
		
		# die or flash brighter when taking damage
		if current_health == 0:
			die()
	get():
		return current_health

@export var sprite: Sprite2D = null

func _ready() -> void:
	visible = false
	call_deferred("start_flashing")

func start_flashing():
	# start flashing the orange bar
	var anim: Animation = $AnimationPlayer.get_animation("flashing_orange_bar")
	var track_index := 0
	anim.track_set_key_value(track_index, 0, orange_bar.tint_progress)
	anim.track_set_key_value(track_index, 2, orange_bar.tint_progress)
	$AnimationPlayer.play("flashing_orange_bar")

func take_damage(amount: int) -> void:
	if not visible:
		visible = true
	current_health -= amount

func die() -> void:
	parent.die()
