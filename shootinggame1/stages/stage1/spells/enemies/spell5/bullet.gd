extends BulletRoot

@export var dir := 0.0
@export var speed := 150.0
@export var min_speed := 100.0
@export var sprite_idx := 2

@onready var sprite : Sprite2D = $Sprite
@onready var notifier : VisibleOnScreenNotifier2D = $Notifier

var speed_vec : Vector2

func ready() -> void:
	sprite.region_rect = Rect2(128, 16 * sprite_idx, 16, 16)
	speed_vec = Vector2(cos(dir),sin(dir))
	rotation = dir

func _process(delta: float) -> void:
	var tmp = max((GameManager.Player.position - global_position).length(),10)
	tmp = 200.0 / pow(tmp,1.4)
	speed -= tmp
	min_speed = max(min_speed - tmp,15.0)
	speed = max(speed - 20.0, min_speed)
	position += speed_vec * speed * delta
