extends Node2D

@onready var bullet := preload("bullet.tscn")

var wave := preload("wave.tscn")
var interval := 0.0
var count := 0

func generate_bullet(dir : float, offset : float):
	var tmp := bullet.instantiate()
	tmp.position = global_position
	tmp.rotation = dir + offset
	tmp.sprite_idx = count - 1
	tmp.speed = 300.0 / (absf(offset) + 1)
	GameManager.BulletPool.add_child(tmp)

func generate_wave(dir : float):
	for i in range(-20, 21):
		generate_bullet(dir, TAU / 41 * i)

func _process(delta: float) -> void:
	interval += delta
	if interval > 0.3 * count:
		if count == 16:
			queue_free()
			return
		count += 1
		generate_wave(global_position.angle_to_point(GameManager.Player.global_position))
