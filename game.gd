extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Singleton.game = self
	_resize_viewport()
	get_tree().root.size_changed.connect(_resize_viewport)

func _resize_viewport():
	var size = DisplayServer.window_get_size()
	$SubViewportContainer/SubViewport.size = size
