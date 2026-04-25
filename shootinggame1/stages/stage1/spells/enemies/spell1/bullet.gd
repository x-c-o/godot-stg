extends BulletRoot

@export var limit := 0.5

var speed := 500.0
var interval := 0.0

func _process(delta: float) -> void:
	interval += delta
	modulate = Color.from_hsv(min(interval,limit), interval * 0.2, 1, 1)
	position += abs(speed) * delta * Vector2(cos(rotation),sin(rotation))
	speed -= 10

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
