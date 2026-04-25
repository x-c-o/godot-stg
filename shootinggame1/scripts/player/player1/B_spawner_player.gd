extends Node2D

@onready var spawner = $".."

@export var shoot_interval := 0.03

var bullet_player := preload("res://scenes/player/player1/bullet_player.tscn")
var interval := 0.0
var is_shooting := false

func generate_bullet_player(ox : float, oy : float):
	var tmp := bullet_player.instantiate()
	tmp.position = global_position + Vector2(ox, oy)
	GameManager.PlayerBulletPool.add_child(tmp)

func shoot() -> void:
	generate_bullet_player(-10, 0)
	generate_bullet_player(10, 0)

func _process(delta: float) -> void:
	interval += delta
	if spawner.is_shooting:
		if !is_shooting:
			is_shooting = true
			if interval >= shoot_interval:
				interval = 0
				shoot()
		else:
			if interval >= shoot_interval:
				interval -= shoot_interval
				shoot()
	else:
		is_shooting = false
