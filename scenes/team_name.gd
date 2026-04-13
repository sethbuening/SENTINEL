extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.player_turn_started.connect(update)
	GameManager.enemy_turn_started.connect(update)
	
	# Sync immediately with current phase
	if GameManager.is_player_turn():
		text = "PLAYER"
	else:
		text = "ENEMIES"

func update(_turn_number: int = 0):
	if GameManager.is_player_turn():
		text = "PLAYER"
	else:
		text = "ENEMIES"
