extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.energy_changed.connect(update)
	
func update(remaining_energy: int, max_energy: int):
	text = "Energy: " + str(remaining_energy) + " / " + str(max_energy)
