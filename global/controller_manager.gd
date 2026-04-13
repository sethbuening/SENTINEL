extends Node

var inventory: Array = [null, null, null, null, null, null, null, null, null, null]

signal gold_changed
signal silver_changed
signal selected_tower_changed(t: tower)

var gold: int = 0:
	set(value):
		gold = value
		gold_changed.emit()
	get:
		return gold
		
var silver: int = 0:
	set(value):
		silver = value
		silver_changed.emit()
	get:
		return silver

var hovered_tower: tower

var selected_tower: tower:
	set(value):
		if selected_tower == value:
			return

		# Remove highlight from old one
		if selected_tower:
			selected_tower.set_selected(false)

		selected_tower = value

		# Add highlight to new one
		if selected_tower:
			selected_tower.set_selected(true)
		
		selected_tower_changed.emit(value)
	get:
		return selected_tower

var double_click_timer: float = 0.25
var click_num: int = 0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse_left"):
		selected_tower = hovered_tower
	if Input.is_action_just_pressed("activate_tower"):
		if GameManager.can_activate_tower(selected_tower):
			GameManager.activate_tower(selected_tower)
	if Input.is_action_just_pressed("end_turn"):
		GameManager.end_player_turn()
