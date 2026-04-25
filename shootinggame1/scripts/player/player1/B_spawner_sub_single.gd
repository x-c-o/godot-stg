extends Sprite2D

@onready var shader_material : ShaderMaterial = material

var start_angle := 0.0
var timer := 0.0
var is_hide := false
var brightness := 0.0
var radius := 0.0

var bullet_follow := preload("res://scenes/player/player1/bullet_sub.tscn")

func set_start_angle(angle):
	if angle == null:
		is_hide = true
		hide()
	else:
		if is_hide:
			is_hide = false
			show()
			brightness = 1.0
		start_angle = angle

func shoot():
	var tmp := bullet_follow.instantiate()
	tmp.position = global_position
	GameManager.PlayerBulletPool.add_child(tmp)

func _process(_delta: float) -> void:
	rotation = - timer
	var angle := start_angle + timer
	position = radius * Vector2(cos(angle), sin(angle))
	shader_material.set_shader_parameter("brightness", brightness)
	brightness += (0.0 - brightness) * 0.1
