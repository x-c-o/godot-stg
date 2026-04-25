extends Node2D

@export var count := 12
@export var dir := 0.0
@export var rotate_speed := 1.0

@onready var bullet := preload("bullet.tscn")

var children : Array[Node2D]
var start_time := 0.0
var speed_vec : Vector2
var speed := 0.0

func generate_bullet(x : float, y : float):
	var tmp = bullet.instantiate()
	children.push_back(tmp)
	tmp.tmp_position = Vector2(x, y)
	tmp.rotation = atan2(y,x)
	add_child(tmp)

func generate_square(bullet_count : int, length := 100.0):
	var p := length / 2
	var pos := - p
	for i in range(bullet_count):
		pos += length / bullet_count
		generate_bullet(p, pos)
		generate_bullet(- p, - pos)
		generate_bullet(- pos, p)
		generate_bullet(pos, - p)

func update_ratio(ratio : float):
	for i in children:
		if i != null:
			i.position = i.tmp_position * ratio

func _ready() -> void:
	speed_vec = Vector2(cos(dir),sin(dir))
	start_time = Time.get_ticks_msec()
	generate_square(count)

func _process(delta: float) -> void:
	var tmp := cos((Time.get_ticks_msec() - start_time) * 0.001)
	update_ratio(2.0 - 1.5 * tmp)
	rotation += delta * rotate_speed
	speed = 100 + 100 * tmp
	position += delta * speed * speed_vec

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
