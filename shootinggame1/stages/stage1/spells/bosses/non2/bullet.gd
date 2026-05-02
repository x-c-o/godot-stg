extends BulletRoot

var rect : Rect2
var speed := 1000.0
var speed_vec : Vector2

var mx_speed := 1.0

func ready() -> void:
	$Sprite2D.region_rect = rect
	speed_vec = Vector2.from_angle(rotation)

func _process(delta: float) -> void:
	position += speed_vec * speed * delta
	speed = max(speed - 20.0, mx_speed)
	mx_speed *= 1.03
	if GameManager.out_of_stage(position):
		queue_free()
