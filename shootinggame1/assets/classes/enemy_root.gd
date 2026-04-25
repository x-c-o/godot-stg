extends FoeRoot

class_name EnemyRoot

@export var pos := Vector2(0,0)
@export var curve : Curve2D
@export var speed_curve : Curve
@export var interval : float
@export var path_scale := Vector2(1, 1)
@export var count_dian := 5
@export var count_power := 5

@onready var health_bar : ProgressBar = $HealthBar

var gradient := preload("res://assets/gradiants/health_bar.tres")
var fill := preload("res://assets/styleboxes/health_bar_fill.tres")
var eff_destroy := preload("res://scenes/effects/eff_destroy.tscn")

var item_dian := preload("res://scenes/items/item_dian.tscn")
var item_power := preload("res://scenes/items/item_power.tscn")

var current_interval := 0.0
var current_ratio := 0.0
var shown_health_bar := false

func _on_foe_end():
	call_deferred("generate_item", item_dian, count_dian)
	call_deferred("generate_item", item_power, count_power)
	destroy()

func generate_item(item : PackedScene, count : int):
	for i in range(count):
		var tmp := item.instantiate()
		tmp.position = position + Vector2(randf_range(-32, 32), randf_range(-32, 32))
		GameManager.ItemPool.add_child(tmp)

func destroy():
	var tmp := eff_destroy.instantiate()
	tmp.position = global_position
	GameManager.EffectPool.add_child(tmp)
	SFXManager.se_enep00.play()
	queue_free()

func update_health() -> void:
	if health_bar.value > 0.0 and health <= 0.0:
		foe_end.emit()
	health_bar.max_value = max_health
	health_bar.value = health
	if is_queued_for_deletion():
		return
	if shown_health_bar:
		health_bar.show()
	elif max_health - health > 0.001:
		shown_health_bar = true
		health_bar.show()
	var style_box = fill.duplicate()
	style_box.bg_color = gradient.sample(health / max_health)
	health_bar.add_theme_stylebox_override("fill",style_box)

func _ready() -> void:
	collision_layer = 4
	collision_mask = 16 + 32
	auto_flip = true
	GameManager.enemy_clear.connect(destroy)
	sprite = $Sprite
	health_bar.hide()
	position = get_pos(0.0)

func get_pos(ratio):
	return pos + get_point(curve, speed_curve, path_scale, ratio)

func tick(delta: float) -> void:
	current_interval += delta
	current_ratio = current_interval / interval
	position = get_pos(current_ratio)
	if current_ratio > 1.0:
		queue_free()
