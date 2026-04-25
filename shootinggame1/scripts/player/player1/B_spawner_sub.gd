extends Node2D

@onready var spawner = $".."

@export var shoot_interval := 0.1

@onready var sub := [
	$Sub1,
	$Sub2,
	$Sub3,
	$Sub4
]

var bullet_sub := preload("res://scenes/player/player1/bullet_sub.tscn")
var radius := calc_radius()
var sub_count : int = 0
var interval := 0.0
var timer := 0.0
var is_shooting := false
const angles := [
	[null, null, null, null],
	[0, null, null, null],
	[0, TAU / 2, null, null],
	[0, TAU / 3, TAU * 2 / 3, null],
	[0, TAU / 4, TAU / 2, TAU * 3 / 4]
]

func set_start_angle():
	for i in range(4):
		sub[i].set_start_angle(angles[sub_count][i])

func calc_radius() -> float:
	return 40 if GameManager.Player.is_slow else 100

func shoot():
	for i in range(sub_count):
		sub[i].shoot()

func _process(delta: float) -> void:
	interval += delta
	timer += delta
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
	radius += (calc_radius() - radius) * 0.2
	for i in range(sub_count):
		sub[i].radius = radius
		sub[i].timer = timer
