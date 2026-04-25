extends Node2D

var Bullet := preload("bullet.tscn")
var bullet

@export var interval := 0.1

var current_interval := 0.0
var tmp := 0

func _process(delta) -> void:
	current_interval += delta
	if current_interval > interval:
		current_interval -= interval
		tmp = (tmp + 1) % 20
		if tmp < 10:
			var pos := Vector2(-200 + 40 * tmp,-50)
			for i in range(10):
				bullet = Bullet.instantiate()
				bullet.get_child(0).modulate = Color.from_hsv(0.7 + 0.03 * tmp,0.3,0.9)
				bullet.position = pos
				bullet.dir = tmp * 0.18 + i * TAU / 10
				add_child(bullet)
