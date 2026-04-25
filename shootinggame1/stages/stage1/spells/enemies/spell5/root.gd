extends Node2D

@export var sprite_idx := 2

var bullet_group := preload("bullet_group.tscn")
var interval := 0.0

func _process(delta: float) -> void:
	interval += delta
	if interval > 2.0:
		interval -= 2.0
		var tmp := bullet_group.instantiate()
		tmp.position = global_position
		tmp.sprite_idx = sprite_idx
		GameManager.BulletPool.add_child.call_deferred(tmp)
