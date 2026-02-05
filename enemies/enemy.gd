extends CharacterBody2D
class_name Enemy

@warning_ignore("shadowed_global_identifier")
var effects: Dictionary = {} # the amount of each effect applied to this creature

var movement_enabled: bool = true

func _ready() -> void:
	pass
	# material for flashing enemies when they take damage
	#$Sprite2D.material = $Sprite2D.material.duplicate()

func _physics_process(_delta: float) -> void:
	if movement_enabled:
		move_and_slide()
