extends BulletRoot

var dir : float
var v : Vector2
var g := 250.0

func _process(delta: float) -> void:
	position += v * delta
	v.y += g * delta
	rotation = atan2(v.y, v.x)
	if GameManager.out_of_stage(position, 10000, 64, 64, 64):
		queue_free()
