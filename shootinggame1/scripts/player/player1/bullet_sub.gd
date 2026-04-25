extends Area2D

@export var damage := 0.5

var effect := preload("res://scenes/effects/eff_splash.tscn")
var dir := - PI / 2
var speed_vec : Vector2

var aim = null
var enemy_pool := GameManager.EnemyPool
var boss_pool := GameManager.BossPool

func change_aim():
	var siz := boss_pool.get_child_count()
	if siz != 0:
		aim = boss_pool.get_child(0)
	else:
		siz = enemy_pool.get_child_count()
		if siz != 0:
			aim = enemy_pool.get_child(0)

func _ready() -> void:
	change_aim()

func _process(delta: float) -> void:
	if aim == null:
		change_aim()
	if aim != null:
		dir += clamp(position.angle_to_point(aim.position) - dir, - 0.05, 0.05)
	speed_vec = Vector2(cos(dir), sin(dir))
	position += delta * 700.0 * speed_vec
	rotation = dir
	if GameManager.out_of_stage(position, 32, 128, 32, 32):
		queue_free()

func hit() -> void:
	var tmp = effect.instantiate()
	tmp.position = position
	GameManager.EffectPool.add_child(tmp)
	queue_free()
