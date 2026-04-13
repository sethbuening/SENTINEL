extends Camera2D

# Camera movement settings
@export var move_speed: float = 300.0
@export var sprint_multiplier: float = 2.0

# Zoom settings
@export var zoom_speed: float = 10
@export var min_zoom: float = 1   # zoomed out
@export var max_zoom: float = 3   # zoomed in to this far

func _process(delta: float) -> void:
	# -------- Movement --------
	var input_dir := Vector2.ZERO
	
	if Input.is_key_pressed(KEY_D):
		input_dir.x += 1
	if Input.is_key_pressed(KEY_A):
		input_dir.x -= 1
	if Input.is_key_pressed(KEY_S):
		input_dir.y += 1
	if Input.is_key_pressed(KEY_W):
		input_dir.y -= 1
	
	input_dir = input_dir.normalized()
	
	if input_dir != Vector2.ZERO:
		position += input_dir * move_speed * 1/zoom * delta


# -------- Zoom Input --------
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_apply_zoom(zoom_speed * 0.1)
			
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_apply_zoom(-zoom_speed * 0.1)


func _apply_zoom(amount: float) -> void:
	var new_zoom := zoom + Vector2.ONE * amount
	
	# Clamp zoom
	new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
	new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)
	
	zoom = new_zoom
