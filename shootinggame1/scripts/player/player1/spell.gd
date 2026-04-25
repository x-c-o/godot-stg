extends Area2D

var damage_per_frame := 0.5
var enemy_pool := GameManager.EnemyPool
var boss_pool := GameManager.BossPool
var aim = null
var dir : float
var begin_dir : float
var speed : float
var speed_vec : Vector2
var interval := 0.0
var lifetime := randf_range(4.8, 5.2)

func change_aim():
	var siz := boss_pool.get_child_count()
	if siz != 0:
		aim = boss_pool.get_child(randi_range(0, siz - 1))
	else:
		siz = enemy_pool.get_child_count()
		if siz != 0:
			aim = enemy_pool.get_child(randi_range(0, siz - 1))

func _ready() -> void:
	begin_dir = dir
	scale = Vector2(0., 0.)
	change_aim()

func _process(delta: float) -> void:
	if !monitorable:
		scale += 10.0 * Vector2(delta, delta)
		modulate.a -= 6.0 * delta
		if modulate.a < 0:
			queue_free()
		return
	interval += delta
	var ratio1 : float = ease(interval, 0.5) # 待调参
	var ratio2 : float = ease(interval / 5.0, 0.5)
	var ratio3 : float = ease(interval - lifetime + 1.1, 4.0)
	scale = Vector2(ratio1, ratio1)
	speed = lerp(600., 0., ratio3)
	if aim == null:
		change_aim()
	if aim != null:
		dir += clamp(position.angle_to_point(aim.position) - dir, - 0.03 * ratio2, 0.03 * ratio2)
	speed_vec = Vector2.from_angle(dir)
	position += lerp(
		GameManager.Player.global_position - global_position
			+ lerp(0.0, 100.0, interval) * Vector2.from_angle(begin_dir + 5.0 * interval),
		delta * speed * speed_vec,
		ratio2
	)
	rotation += 2.0 * delta
	if interval > lifetime:
		interval = 0.0
		monitorable = false
		damage_per_frame = 4.0
		GameManager.apply_shake(10.0, 0.1)

func hit():
	pass
