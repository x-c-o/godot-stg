extends Node3D

@onready var light1 := $L1
@onready var light2 := $L2
@onready var light3 := $L3
@onready var light4 := $L4

var interval := 0.0
var offset := randf_range(0, TAU)

func calc(p) -> float:
	return smoothstep(0.0, 0.05, p) - smoothstep(0.05, 0.2, p)

func _process(delta: float) -> void:
	interval += delta
	var p : float = min(1.0, fmod(interval + offset, 4.1))
	var p2 : float = min(1.0, fmod(interval + offset, 5.2))
	var e = calc(p) + calc(p2)
	e = 2.0 - e
	light1.light_energy = e
	light2.light_energy = e
	light3.light_energy = e
	light4.light_energy = e
