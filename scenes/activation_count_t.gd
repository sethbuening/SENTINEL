extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.activations_changed.connect(update)
	
func update(remaining: int, _max_activations: int = 0):
	text = str(remaining)
