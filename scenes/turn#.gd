extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.player_turn_started.connect(update)

func update(turn_number: int):
	text = str(turn_number)
