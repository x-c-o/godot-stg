extends Node2D

var Bullet_red := preload("bullet_red.tscn")
var Bullet_blue := preload("bullet_blue.tscn")
var interval_red := 0.0
var interval_blue := 0.0
var bullet
var dir := 0.0
var speed_dir := 0.0

func _process(delta: float) -> void:
	interval_red += delta
	interval_blue += delta
	if interval_red > 1.0:
		interval_red -= 1.0
		var ran = randf_range(0,TAU)
		for i in range(36):
			bullet = GameManager.ps(Bullet_red, GameManager.BulletPool)
			bullet.dir = ran + TAU / 36 * i
			bullet.position = global_position
	if interval_blue > 0.05:
		interval_blue -= 0.05
		bullet = GameManager.ps(Bullet_blue, GameManager.BulletPool)
		bullet.dir = dir
		bullet.position = global_position
		dir += speed_dir
		speed_dir += 0.005
