extends Node2D

var radius: float = 100.0
var fill_color: Color = Color(0.009, 0.286, 0.406, 0.2)
var border_color: Color = Color(0.0, 0.405, 0.641, 1.0)
var border_width: float = 0.5

func _draw():
	# Filled transparent circle
	draw_circle(Vector2.ZERO, (radius / 4), fill_color)
	
	# Border
	draw_arc(Vector2.ZERO, (radius / 4), 0, TAU, 128, border_color, border_width)
