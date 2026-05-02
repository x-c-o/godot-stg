extends Node2D

var bullet := preload("bullet.tscn")
var interval := 0.0
var rot := 0.0
var rect := Rect2(160, 0, 16, 16)

var v_rot := 0.2

func _process(delta: float) -> void:
	interval += delta
	if interval >= 0.05:
		interval -= 0.05
		for i in range(5):
			var tmp := GameManager.ps(bullet, GameManager.BulletPool)
			tmp.rotation = rot + TAU / 5 * i
			tmp.position = global_position
			tmp.rect = rect
		rot += v_rot
