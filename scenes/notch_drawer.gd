extends Node2D

@export var max_health: int = 10
@export var color: Color = Color(0.0, 0.0, 0.0, 1.0)

@onready var bar: TextureProgressBar = get_parent().get_node("RedBar")

func _ready():
	queue_redraw()

func set_max_health(value: int):
	max_health = max(1, value)
	queue_redraw()

func _draw():
	if max_health <= 1 or bar == null:
		return

	# Get the bar's global rect
	var bar_pos := bar.global_position
	var bar_size := bar.size

	# Convert bar position into this Node2D's local space
	var local_bar_pos: Vector2 = to_local(bar_pos)

	var segment_w := bar_size.x / max_health
	for i in range(1, max_health):
		var x: float = local_bar_pos.x + (i * segment_w * 42) # TODO: 42 is magic number
		if (i % 5 == 0):
			draw_line(
				Vector2(x, local_bar_pos.y),
				Vector2(x, local_bar_pos.y + bar_size.y * 2.5),
				color,
				50
			)
		else:
			draw_line(
				Vector2(x, local_bar_pos.y),
				Vector2(x, local_bar_pos.y + bar_size.y * 1.75),
				color,
				25
			)
