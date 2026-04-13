extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ControllerManager.gold_changed.connect(update)

func update():
	text = str(ControllerManager.gold)
