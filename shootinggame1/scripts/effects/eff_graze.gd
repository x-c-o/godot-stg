extends Sprite2D

var speed_vec : Vector2
var speed := 800.0

func _ready() -> void:
	var tmp = randf_range(0, TAU)
	speed_vec = Vector2(cos(tmp), sin(tmp))

func _process(delta: float) -> void:
	position += speed * delta * speed_vec
	speed = max(0.0, speed - 2000.0 * delta)
	scale -= Vector2(0.1, 0.1)
	if scale.x < 0.0:
		queue_free();
