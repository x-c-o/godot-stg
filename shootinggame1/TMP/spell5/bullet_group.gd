extends Line2D

@export var sprite_idx := 2

var Bullet := preload("bullet.tscn")
var bullet := []

func _ready() -> void:
	var ran = randf_range(0,TAU)
	for i in range(72):
		bullet.append(Bullet.instantiate())
		bullet[i].dir = ran + TAU / 72 * i
		bullet[i].sprite_idx = sprite_idx
		add_child(bullet[i])
		add_point(Vector2(0.0,0.0))

func _process(delta: float) -> void:
	for i in range(72):
		set_point_position(i,bullet[i].position)
