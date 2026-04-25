extends Node2D

var bullet := preload("bullet.tscn")
var interval := 0.0
var count := 0

func generate_wave(limit : float):
	SFXManager.se_tan01.play()
	for i in range(20):
		var tmp = bullet.instantiate()
		tmp.rotation = TAU / 20 * i
		tmp.limit = limit
		tmp.position = global_position
		GameManager.BulletPool.add_child(tmp)

func _process(delta: float) -> void:
	interval += delta
	if interval > 0.5 * count:
		if count == 10:
			queue_free()
			return
		count += 1
		generate_wave(0.1 * count - 0.1)
