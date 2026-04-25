extends Node2D

const eps := 1e-5
func ge(a : float, b : float):
	return a - b >= -eps

@onready var SpawnerPlayer := $SpawnerPlayer
@onready var SpawnerSub := $SpawnerSub

var is_shooting := false

func shoot():
	is_shooting = true

func stop_shoot():
	is_shooting = false

func _on_power_changed(power):
	if ge(power, 4.0):
		SpawnerSub.sub_count = 4
	elif ge(power, 3.0):
		SpawnerSub.sub_count = 3
	elif ge(power, 2.0):
		SpawnerSub.sub_count = 2
	elif ge(power, 1.0):
		SpawnerSub.sub_count = 1
	else:
		SpawnerSub.sub_count = 0
	SpawnerSub.set_start_angle()
