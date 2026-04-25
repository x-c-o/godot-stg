extends Node3D

@onready var lantern := preload("res://scenes/models/lantern.tscn")
@onready var grass := preload("res://scenes/models/grass1.tscn")
@onready var camera := $Camera3D
@onready var environ := $WorldEnvironment
@onready var particle := $GPUParticles3D

var interval := 0.0
var lantern_z := 0.0
var grass_z := 0.0

func generate(scene : PackedScene,pos : Vector3, lifetime := 20.0):
	var tmp := scene.instantiate()
	tmp.position = pos
	add_child(tmp)
	get_tree().create_timer(lifetime).timeout.connect(func(): tmp.queue_free())

func generate_group(scene : PackedScene, z : Vector3, o := 4.0):
	generate(scene, z + Vector3(o, 0, 0))
	generate(scene, z + Vector3(-o, 0, 0))

func upd():
	while lantern_z - camera.position.z < 180.0:
		generate_group(lantern, Vector3(0, 0, lantern_z))
		lantern_z += 10.0
	while grass_z - camera.position.z < 180.0:
		generate_group(grass, Vector3(0, -1.9, grass_z), 6.0)
		generate_group(grass, Vector3(0, -1.9, grass_z), 10.0)
		grass_z += 2.0

func _ready() -> void:
	upd()

func _process(delta: float) -> void:
	interval += delta
	environ.environment.fog_sky_affect = lerp(1.0, 0.8, ease((interval - 4.0) / 10.0, 3.0))
	environ.environment.fog_density = lerp(0.1, 0.01, ease((interval - 20.0) / 10.0, -3.0))
	upd()
	camera.position.z += 10.0 * delta
	camera.rotation.x = sin(interval * 0.8 + 0.5) * 0.2 + 0.1
	camera.rotation.y = sin(interval * 1.2 + 0.2) * 0.1 - PI
	camera.rotation.z = sin(interval) * 0.1
	particle.position = camera.position + Vector3(0, 1, 20)
