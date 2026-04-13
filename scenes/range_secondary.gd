extends Node2D

var radius: float = 100.0
var fill_color: Color = Color(0.507, 0.014, 0.089, 0.2) # 0.407, 0.199, 0.008, 0.2 # orange colors
var border_color: Color = Color(0.521, 0.072, 0.159, 1.0) # 0.621, 0.262, 0.042, 1.0
var border_width: float = 0.5

func _draw():
	# Filled transparent circle
	draw_circle(Vector2.ZERO, radius / 4, fill_color)
	
	# Border
	draw_arc(Vector2.ZERO, radius / 4, 0, TAU, 128, border_color, border_width)
