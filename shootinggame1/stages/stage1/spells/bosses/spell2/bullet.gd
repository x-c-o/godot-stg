extends BulletRoot

var dir : float
var v : Vector2
var g := 250.0

#var interval := 0.0

func _process(delta: float) -> void:
	position += v * delta
	v.y += g * delta
	rotation = atan2(v.y, v.x)
	#interval += delta
	#if interval > 4.5:
		#v.x *= 1.1
	if GameManager.out_of_stage(position, 10000, 64, 64, 64):
		queue_free()
