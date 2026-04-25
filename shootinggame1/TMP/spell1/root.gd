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
	if interval_red > 0.5:
		interval_red -= 0.5
		var ran = randf_range(0,TAU)
		for i in range(36):
			bullet = Bullet_red.instantiate()
			bullet.dir = ran + TAU / 36 * i
			add_child(bullet)
	if interval_blue > 0.03:
		interval_blue -= 0.03
		bullet = Bullet_blue.instantiate()
		bullet.dir = dir
		add_child(bullet)
		dir += speed_dir
		speed_dir += 0.005
