extends Area2D

@export var speed := 270
@export var speed_slow := 120
@export var sprite : SpriteFrames
@export var bullet_spawner : PackedScene
@export var spell_spawner : PackedScene
@export var lt := Vector2(0,0)
@export var rb := Vector2(0,0)
@export var item_get_radius := 100.0
@export var item_get_radius_slow := 250.0
@export var graze_radius := 50.0
@export var max_power := 4.0
@export var power := 0.0
@export var score := 0

@onready var _chara := $Chara
@onready var _border := $Border
@onready var _bullet_spawner : Node2D
@onready var _spell_spawner : Node2D
#@onready var _collision := $Collision
@onready var _item_get_circ := $ItemGetCirc

var is_slow = false
var hor_speed = 0
var current_item_get_radius := 0.0
var circ_width := 50.0

signal power_changed(power : float, max_power : float)
signal score_changed(value : int)

func _ready() -> void:
	GameManager.Player = self
	_bullet_spawner = bullet_spawner.instantiate()
	add_child(_bullet_spawner)
	_spell_spawner = spell_spawner.instantiate()
	add_child(_spell_spawner)
	emit_signal("power_changed", power, max_power)
	emit_signal("score_changed", score)
	_chara.sprite_frames = sprite
	_chara.play("idle")

func _process(delta: float) -> void:
	var press = [Input.get_action_strength("move_left"),Input.get_action_strength("move_right"),
		Input.get_action_strength("move_up"),Input.get_action_strength("move_down"),
		Input.get_action_strength("slow"),Input.get_action_strength("shoot"),
		Input.get_action_strength("spell")]
	var mov = Vector2(press[1]-press[0],press[3]-press[2])
	if(mov.x != hor_speed):
		hor_speed = mov.x
		if mov.x == 1:
			_chara.play("turn_right")
		elif mov.x == -1:
			_chara.play("turn_left")
		else:
			_chara.play("idle")
	if press[4]: # 低速
		if not is_slow:
			is_slow = true
			circ_width = 50.0
		_border.show_border()
		mov *= speed_slow
		current_item_get_radius += (item_get_radius_slow - current_item_get_radius) * 0.1
	else:
		if is_slow:
			is_slow = false
			circ_width = max(circ_width, 2.0)
		_border.hide_border()
		mov *= speed
		current_item_get_radius += (item_get_radius - current_item_get_radius) * 0.1
	if press[5]: # 射击
		_bullet_spawner.shoot()
	else:
		_bullet_spawner.stop_shoot()
	if press[6]: # Spell
		_spell_spawner.cast()
	if mov.x and mov.y:
		mov.x *= 0.7071
		mov.y *= 0.7071
	position += mov * delta
	position.x = clamp(position.x, -lt.x, rb.x)
	position.y = clamp(position.y, -lt.y, rb.y)
	_item_get_circ.scale = Vector2(current_item_get_radius, current_item_get_radius)
	_item_get_circ.width = circ_width / current_item_get_radius
	circ_width += (0.0 - circ_width) * 0.1

func _on_area_entered(area: Area2D) -> void:
	match area.collision_layer:
		2 : # 敌弹
			print("ENTERED Bullet : ",area)
		64 : # 物品
			match area.ID:
				"P":
					power = min(power + 0.1, max_power)
					emit_signal("power_changed", power, max_power)
					print("power_changed!")
				"D":
					score += 1
					emit_signal("score_changed", score)
					print("score_changed!")
			area.queue_free()
			print("ENTERED Item : ",area)

func _on_power_changed(_power: float, _max_power: float) -> void:
	_bullet_spawner._on_power_changed(_power)

func _on_graze_area_entered(area: Area2D) -> void:
	area.graze()
