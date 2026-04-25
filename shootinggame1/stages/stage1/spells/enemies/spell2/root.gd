extends Node2D

@export var start_color : float

var bullet := preload("bullet.tscn")
var interval := 0.0
var count := 0

func _process(delta: float) -> void:
	interval += delta
	if interval > 0.05 * count:
		if count == 30:
			queue_free()
			return
		count += 1
		var tmp = bullet.instantiate()
		tmp.color = start_color
		tmp.color = count * 0.015 + start_color
		tmp.position = global_position
		tmp.rotation = randf_range(0, TAU)
		GameManager.BulletPool.add_child(tmp)
