extends BulletRoot

@export var dir := 0.0
@export var speed := 500.0
var speed_vec : Vector2

func ready() -> void:
	speed_vec = Vector2.from_angle(dir)
	rotation = dir

func _process(delta: float) -> void:
	position += speed_vec * speed * delta
	speed = max(speed - 20, 100)
	if GameManager.out_of_stage(position):
		queue_free()
