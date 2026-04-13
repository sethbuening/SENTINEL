extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ControllerManager.silver_changed.connect(update)

func update():
	text = str(ControllerManager.silver)
