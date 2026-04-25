extends Node2D

@onready var Trail = $Trail
@onready var Bullet = $Bullet

@export var dir := 0.0
@export var offset := 100.0
@export var speed := 200.0

var start := 0.0
var speed_vec := Vector2(0.0,0.0)
var offset_vec := Vector2(0.0,0.0)
var bounce : Vector2
var current_interval := 0.0
var out_of_screen := false

func _ready() -> void:
	start = Time.get_ticks_msec()
	speed_vec = Vector2(cos(dir),sin(dir))
	offset_vec = Vector2(-speed_vec.y,speed_vec.x)

func _process(delta: float) -> void:
	current_interval += delta
	if out_of_screen:
		if Trail.get_point_count() == 0:
			queue_free()
		else:
			Trail.remove_point(0)
	else:
		Trail.add_point(Bullet.position)
		if Trail.get_point_count() > 50:
			Trail.remove_point(0)
		var tmp = sin(0.008 * (Time.get_ticks_msec() - start))
		Bullet.rotation += 4.0 * delta
		Bullet.position += delta * (speed * speed_vec + offset * tmp * offset_vec)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	out_of_screen = true
