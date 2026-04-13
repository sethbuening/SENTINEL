extends Sprite2D
class_name tower

@export var tower_resource: tower_r

# towers need to receive a death signal to be able to destroy that tower's references
var connections: Array[tower] = []
var health_bar: Node2D
var tilemap_position: Vector2i
@onready var outline: Sprite2D = $Outline

signal death(t: tower)

@onready var range_primary: Sprite2D = $Range_Primary
@onready var range_secondary: Sprite2D = $Range_Secondary

func _ready() -> void:
	# setup resources
	tower_resource = tower_resource.duplicate(true)
	tower_resource.primary = tower_resource.primary.duplicate()
	tower_resource.secondary = tower_resource.secondary.duplicate()
	tower_resource.primary.setup(self)
	tower_resource.secondary.setup(self)
	
	# setup range overlays
	range_primary.radius = tower_resource.primary.range
	range_secondary.radius = tower_resource.secondary.range
	
	# setup sprites
	texture = tower_resource.sprite
	outline.texture = tower_resource.sprite
	
	# setup health bar
	health_bar = get_node("HealthBar")
	health_bar.get_node("RedBar").tint_progress = Color(0.278, 0.145, 0.874, 1.0)
	health_bar.get_node("OrangeBar").tint_progress = Color(0.895, 0.0, 0.435, 1.0)
	health_bar.MAX_HEALTH = DataManager.towers[tower_resource.type].max_health
	health_bar.current_health = health_bar.MAX_HEALTH
	#take_damage(1)
	
	# setup connections
	call_deferred("connect_towers")

func connect_towers():
	for t in Singleton.game.get_children():
		if (t is tower) and not (t == self):
			t = t as tower
			if t.global_position.distance_to(global_position) < 500:
				connections.append(t)
				t.death.connect(remove_connection)
	queue_redraw()


func primary():
	tower_resource.primary.cast()
	#region flash tower during activation
	'''var tween := create_tween()
	tween.tween_property(self, "modulate", Color(2, 2, 2, 2), 0.2)
	get_tree().create_timer(0.2).timeout.connect(func():
		tween = create_tween()
		tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.2)
	)'''
	#endregion
	for t in connections:
		t.secondary()

func secondary():
	tower_resource.secondary.cast()

func build(loc: Vector2i) -> void:
	tilemap_position = loc
	%TowerGrid.set_cell(loc, 1, tower_resource.atlas_coord)
	for i in range(8):
		var position: Vector2i = loc + Vector2i()
		%TowerGrid.set_cell()

func take_damage(amount: int) -> void:
	if health_bar:
		health_bar.take_damage(amount)
	else:
		print("[tower.gd] Could not find health_bar to take damage!")

func die():
	# 0.9 is how long until the healthbar has fully hit zero
	death.emit(self)
	get_tree().create_timer(0.9).timeout.connect(func():
		queue_free()
	)

func remove_connection(t: tower):
	var size: int = connections.size()
	connections.erase(t)
	print("Diff: %d" % (size - connections.size()))

func _draw() -> void:
	#for i in range(tower_resource.polygon.size()):
	#	draw_line(tower_resource.polygon[i], tower_resource.polygon[(i + 1) % tower_resource.polygon.size()], Color.RED, 0.5)
	for t in connections:
		draw_line(
			Vector2.ZERO,
			to_local(t.global_position),
			Color.DEEP_SKY_BLUE,
			0.5
		)

func set_selected(enabled: bool) -> void:
	outline.visible = enabled
	range_primary.visible = enabled
	range_secondary.visible = enabled

func _on_static_body_2d_mouse_shape_entered(_shape_idx: int) -> void:
	ControllerManager.hovered_tower = self

func _on_static_body_2d_mouse_shape_exited(_shape_idx: int) -> void:
	if ControllerManager.hovered_tower == self:
		ControllerManager.hovered_tower = null
