extends Node3D

var lantern := preload("res://scenes/models/lantern2.tscn")
var bamboo := preload("res://scenes/models/bamboo.tscn")
var grass := preload("res://scenes/models/grass1.tscn")
var light := preload("res://stages/stage1/backgrounds/light.tscn")
@onready var camera := $Camera3D
@onready var environ := $WorldEnvironment
@onready var particle := $GPUParticles3D

var interval := 0.0
var lantern_z := 0.0
var bamboo_z := 0.0
var grass_z := 0.0

func generate(scene : PackedScene,pos : Vector3, adjust : Callable, lifetime := 20.0):
	var tmp := scene.instantiate()
	tmp.position = pos
	add_child(tmp)
	get_tree().create_timer(lifetime).timeout.connect(func(): tmp.queue_free())
	adjust.call(tmp)

func generate_group(scene : PackedScene, z : Vector3, adjust : Callable, o := 4.0):
	generate(scene, z + Vector3(o, 0, 0), adjust)
	generate(scene, z + Vector3(-o, 0, 0), adjust)

func adjust_lantern(_a):
	pass

func adjust_bamboo(a):
	a.rotation = Vector3(randf_range(-0.2, 0.2), randf_range(0, TAU), randf_range(-0.2, 0.2))
	a.scale.y *= randf_range(1.0, 1.5)

func adjust_grass(a):
	a.rotation.y = randf_range(0, TAU)

func upd():
	while lantern_z - camera.position.z < 180.0:
		generate_group(lantern, Vector3(0, -1.9, lantern_z), adjust_lantern)
		lantern_z += 45.0
	while bamboo_z - camera.position.z < 380.0:
		generate(bamboo, Vector3(0, -1.9, bamboo_z) + Vector3(randf_range(6.0, 8.0), 0, 0), adjust_bamboo, 40.0)
		generate(bamboo, Vector3(0, -1.9, bamboo_z) - Vector3(randf_range(6.0, 8.0), 0, 0), adjust_bamboo, 40.0)
		generate(bamboo, Vector3(0, -1.9, bamboo_z) + Vector3(randf_range(12.0, 18.0), 0, 0), adjust_bamboo, 40.0)
		generate(bamboo, Vector3(0, -1.9, bamboo_z) - Vector3(randf_range(12.0, 18.0), 0, 0), adjust_bamboo, 40.0)
		generate(bamboo, Vector3(0, -1.9, bamboo_z) + Vector3(randf_range(32.0, 34.0), 0, 0), adjust_bamboo, 40.0)
		generate(bamboo, Vector3(0, -1.9, bamboo_z) - Vector3(randf_range(32.0, 34.0), 0, 0), adjust_bamboo, 40.0)
		bamboo_z += randf_range(3.5, 4.5)
	while grass_z - camera.position.z < 180.0:
		generate(grass, Vector3(0, -1.9, grass_z) + Vector3(randf_range(5.0, 7.0), 0, 0), adjust_grass)
		generate(grass, Vector3(0, -1.9, grass_z) - Vector3(randf_range(5.0, 7.0), 0, 0), adjust_grass)
		generate_group(grass, Vector3(0, -1.9, grass_z), adjust_grass, 10.0)
		grass_z += 2.0

func _ready() -> void:
	upd()

var flash_interval := 0.0

func _process(delta: float) -> void:
	interval += delta
	#environ.environment.fog_sky_affect = lerp(1.0, 0.0, ease((interval - 4.0) / 10.0, 3.0))
	#environ.environment.fog_density = lerp(0.05, 0.01, ease((interval - 20.0) / 10.0, -3.0))
	upd()
	camera.position.z += 10.0 * delta
	camera.rotation.x = sin(interval * 0.8 + 0.5) * 0.2 + 0.1
	camera.rotation.y = sin(interval * 1.2 + 0.2) * 0.1 - PI
	camera.rotation.z = sin(interval) * 0.1
	particle.position = camera.position + Vector3(0, 1, 20)
	if interval > flash_interval:
		var tmp := GameManager.ps(light, self)
		tmp.position = camera.position
		tmp.position.x = lerp(randf_range(-15, -15), randf_range(15, 15), float(randi() % 2))
		tmp.position.y += randf_range(0, 15)
		tmp.position.z += randf_range(30, 50)
		flash_interval += randf_range(0.0, 5.0)
