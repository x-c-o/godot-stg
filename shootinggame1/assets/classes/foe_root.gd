extends Area2D

class_name FoeRoot

signal foe_end

@export var max_health := 10.0:
	set(v):
		max_health = v
		update_health()
@export var health := 10.0:
	set(v):
		health = v
		update_health()
@export var auto_flip := false

@onready var sprite : AnimatedSprite2D

var sprite_status := -1 # [0, 1, 2] = [right, left, idle]
var frame_bullets: Dictionary = {}

func tick(delta): pass
func update_health(): pass
func _on_foe_end(): pass

func get_point(curve : Curve2D, speed_curve : Curve, path_scale : Vector2, ratio : float) -> Vector2:
	return path_scale * curve.sample_baked(speed_curve.sample(ratio) * curve.get_baked_length())

func update_animation_flip(delta_x : float, threshold := 1.0):
	if delta_x > threshold:
		if sprite_status != 0:
			sprite_status = 0
			sprite.scale.x = 1
			sprite.play("turn")
	elif delta_x < -threshold:
		if sprite_status != 1:
			sprite_status = 1
			sprite.scale.x = -1
			sprite.play("turn")
	else:
		if sprite_status == 0:
			sprite_status = 2
			sprite.scale.x = 1
			sprite.play("turn_rev")
		elif sprite_status == 1:
			sprite_status = 2
			sprite.scale.x = -1
			sprite.play("turn_rev")

func update_animation_normal(delta_x : float, threshold := 1.0):
	if delta_x > threshold:
		if sprite_status != 0:
			sprite_status = 0
			sprite.play("turn_right")
	elif delta_x < -threshold:
		if sprite_status != 1:
			sprite_status = 1
			sprite.play("turn_left")
	else:
		if sprite_status == 0:
			sprite_status = 2
			sprite.play("turn_right_rev")
		elif sprite_status == 1:
			sprite_status = 2
			sprite.play("turn_left_rev")

func calc_damage_per_frame():
	for i in frame_bullets.values():
		health -= i.damage_per_frame

func _init() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	foe_end.connect(_on_foe_end)

func _process(delta: float) -> void:
	var tposition := position.x
	tick(delta)
	calc_damage_per_frame()
	if auto_flip:
		update_animation_flip(position.x - tposition)
	else:
		update_animation_normal(position.x - tposition)

func _on_area_entered(area: Area2D) -> void:
	match area.collision_layer:
		16:
			area.hit()
			health -= area.damage
		32:
			frame_bullets[area.get_instance_id()] = area

func _on_area_exited(area: Area2D) -> void:
	match area.collision_layer:
		32:
			frame_bullets.erase(area.get_instance_id())

# TODO 考虑到后续功能，不能用collision_layer来判定伤害计算逻辑，之后再改
# 应当使用进入的area的伤害类型（帧伤/单伤）来计算
# 因为 Bomb 也可以是单伤，自机子弹也可以帧伤
