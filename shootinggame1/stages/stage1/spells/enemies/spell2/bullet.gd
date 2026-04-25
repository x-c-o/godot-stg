extends BulletRoot

@export var color := 0.5

var speed := 800.0
var interval := 0.0

func ready() -> void:
	modulate = Color.from_hsv(color, 0.5, 1)

func _process(delta: float) -> void:
	position += speed * delta * Vector2(cos(rotation),sin(rotation))
	speed = max(speed - 40, 50)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
