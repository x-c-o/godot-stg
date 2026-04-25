extends Line2D

@export var dir := 0.0
@export var pos := Vector2(0.0,0.0)
@export var speed := 80.0
@export var life_time := 8
@export var interval := 0.0
@export var count := 15

var current_interval := 0.0

func _process(delta: float) -> void:
	current_interval += delta
	if count > 0:
		if current_interval > interval:
			current_interval -= interval
			count -= 1
			add_point(pos)
			if get_point_count() > life_time:
				remove_point(0)
			dir += randf_range(-1,1)
			var speed_vec = Vector2(cos(dir),sin(dir))
			pos += speed * delta * speed_vec
	else:
		if get_point_count() == 0:
			queue_free()
		else:
			remove_point(0)
