extends Enemy
class_name Basic_Enemy

@onready var health_bar: Node2D = $HealthBar
var count: int = 0

var textures = {
	Vector2(0, 0): preload("res://art/enemies/enemy_1_ur.png"),
	Vector2(1, 0): preload("res://art/enemies/enemy_1_r.png"),
	Vector2(-1, 0): preload("res://art/enemies/enemy_1_l.png"),
	Vector2(0, 1): preload("res://art/enemies/enemy_1_d.png"),
	Vector2(0, -1): preload("res://art/enemies/enemy_1_u.png"),
	Vector2(1, 1): preload("res://art/enemies/enemy_1_dr.png"),
	Vector2(-1, -1): preload("res://art/enemies/enemy_1_ul.png"),
	Vector2(-1, 1): preload("res://art/enemies/enemy_1_dl.png"),
	Vector2(1, -1): preload("res://art/enemies/enemy_1_ur.png"),
}

func _ready() -> void:
	super._ready()

func _physics_process(_delta: float) -> void:
	'''var dir: Vector2 = (Singleton.player.global_position - global_position).normalized()
	if movement_enabled:
		velocity = speed * dir
		move_and_slide()
	var texture_dir: Vector2 = to_8_direction(dir)
	$Sprite2D.texture = textures[texture_dir]'''
	pass

func take_damage(amount: int) -> void:
	health_bar.take_damage(amount)

func to_8_direction(dir: Vector2) -> Vector2:
	if dir == Vector2.ZERO:
		return Vector2.ZERO

	dir = dir.normalized()

	var x: int = sign(dir.x)
	var y: int = sign(dir.y)

	# Angle thresholds for diagonals (22.5° and 67.5°)
	if abs(dir.x) < 0.382683: # sin(22.5°)
		x = 0
	elif abs(dir.y) < 0.382683:
		y = 0

	return Vector2(x, y)
