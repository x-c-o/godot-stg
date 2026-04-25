extends Node3D

@onready var light := $Light

var interval := 0.0
var offset := randf_range(0, TAU)

func calc(p) -> float:
	return smoothstep(0.0, 0.05, p) - smoothstep(0.05, 0.2, p)

func _process(delta: float) -> void:
	interval += delta
	var p : float = min(1.0, fmod(interval + offset, 4.1))
	var p2 : float = min(1.0, fmod(interval + offset, 5.2))
	var e = calc(p) + calc(p2)
	light.light_energy = 2.0 - e
	rotate_y(delta)
