extends Node2D

var square := preload("square.tscn")
var interval := 0.0
var count := 0

func _process(delta: float) -> void:
	interval += delta
	if interval > 0.7 * count:
		if count == 15:
			queue_free()
			return
		count += 1
		var tmp = square.instantiate()
		tmp.position = global_position
		tmp.dir = global_position.angle_to_point(GameManager.Player.global_position)
		GameManager.BulletPool.add_child(tmp)
