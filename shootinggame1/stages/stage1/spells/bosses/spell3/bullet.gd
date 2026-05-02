extends BulletRoot

@onready var speed_vec := Vector2.from_angle(rotation)
var speed := 100.0
var rect : Rect2

func ready() -> void:
	$Sprite2D.region_rect = rect

func _process(delta):
	position += delta * speed * speed_vec
	speed += 200.0 * delta
	if GameManager.out_of_stage(position):
		queue_free()
