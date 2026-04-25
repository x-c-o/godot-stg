extends Line2D

@export var sprite_idx := 2

var Bullet := preload("bullet.tscn")
var bullet := []

func ready() -> void:
	var ran = randf_range(0,TAU)
	for i in range(50):
		bullet.append(Bullet.instantiate())
		bullet[i].dir = ran + TAU / 50 * i
		bullet[i].sprite_idx = sprite_idx
		add_child(bullet[i])
		add_point(Vector2(0.0,0.0))

func _process(_delta: float) -> void:
	var counter := 0
	for i in range(50):
		if bullet[i] != null:
			set_point_position(i,bullet[i].position)
			if bullet[i].notifier.is_on_screen():
				counter += 1
	if counter == 0:
		queue_free()
