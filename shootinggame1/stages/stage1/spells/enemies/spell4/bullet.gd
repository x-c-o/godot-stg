extends BulletRoot

@export var speed := 800.0
@export var sprite_idx := 1

@onready var sprite := $Sprite

var speed_vec : Vector2
var interval := 0.0

func ready() -> void:
	sprite.region_rect = Rect2(128, 16 * sprite_idx, 16, 16)
	speed_vec = Vector2(cos(rotation),sin(rotation))

func _process(delta: float) -> void:
	position += delta * speed * speed_vec
	if GameManager.out_of_stage(position, 16, 16, 16, 16):
		queue_free()
