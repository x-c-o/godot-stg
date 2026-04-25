extends Node2D

@onready var Trail = $Trail
@onready var Bullet = $Bullet
@export var effect_interval := 0.05

var Player : Node2D
var bounce : Vector2
var effect := preload("effect.tscn")
var current_interval := 0.0

func generate():
	var tmp = effect.instantiate()
	tmp.position = Bullet.position
	tmp.dir = randf_range(0,TAU)
	tmp.speed += randf_range(-100,200)
	add_child(tmp)

func _process(delta: float) -> void:
	current_interval += delta
	if current_interval > effect_interval:
		current_interval -= effect_interval
		for i in range(randi_range(1,5)):
			generate()
	Trail.add_point(Bullet.position)
	if(Trail.get_point_count() > 100):
		Trail.remove_point(0)
	bounce = bounce * 0.95 + (Player.position - Bullet.position) * 0.1
	Bullet.position += bounce
	var tmp = 1.0 + 0.1 * sin(0.01 * Time.get_ticks_msec())
	Bullet.scale = Vector2(tmp,tmp)
