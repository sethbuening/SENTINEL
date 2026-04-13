extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ControllerManager.selected_tower_changed.connect(update)

func update(t: tower):
	if t:
		visible = true
		$PName.text = t.tower_resource.primary.name
		$PDesc.text = t.tower_resource.primary.description
		$SName.text = t.tower_resource.secondary.name
		$SDesc.text = t.tower_resource.secondary.description
		$Health.text = str(t.health_bar.current_health) + "/" + str(t.health_bar.MAX_HEALTH)
	else:
		visible = false
