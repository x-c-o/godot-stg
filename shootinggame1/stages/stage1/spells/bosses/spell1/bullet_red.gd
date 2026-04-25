extends BulletRoot

@export var dir := 0.0
@export var speed := 500.0
var speed_vec : Vector2

func ready() -> void:
	speed_vec = Vector2(cos(dir),sin(dir))
	rotation = dir

func _process(delta: float) -> void:
	position += speed_vec * speed * delta
	speed = max(speed - 20, 100)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	#print("red free")
	queue_free()
