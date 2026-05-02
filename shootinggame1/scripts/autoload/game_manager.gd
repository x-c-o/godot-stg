# 存储全局节点、信号、方法

extends Node

var MainStage : Node2D
var PlayerBulletPool : Node2D
var BulletPool : Node2D
var EffectPool : Node2D
var EnemyPool : Node2D
var ItemPool : Node2D
var BossPool : Node2D
var SpellPool : Node2D
var FixedContainer : Control
var Player : Area2D

var dialogue_ui := preload("res://scenes/dialogues/dialogue_ui.tscn")

signal all_item_collect()
signal enemy_clear()
signal bullet_clear()
signal bullet_clear_point(point : Vector2, radius : float)
signal add_shake(strengh : float)

func in_death_area_down(position : Vector2 , spare : float = 32.0) -> bool:
	return position.y > MainStage.rb.y + spare

func in_death_area_up(position : Vector2 , spare : float = 32.0) -> bool:
	return position.y < - MainStage.lt.y - spare

func in_death_area_right(position : Vector2 , spare : float = 32.0) -> bool:
	return position.x > MainStage.rb.x + spare

func in_death_area_left(position : Vector2 , spare : float = 32.0) -> bool:
	return position.x < - MainStage.lt.x - spare

func out_of_stage(position : Vector2, spare_u : = 32.0, spare_d : = 32.0, spare_l := 32.0, spare_r := 32.0):
	return in_death_area_up(position, spare_u)\
		or in_death_area_down(position, spare_d)\
		or in_death_area_left(position, spare_l)\
		or in_death_area_right(position, spare_r)

## put_scene 的简写，用于将一个场景实例化后放在特定子树中。
func ps(scene : PackedScene, parent : Node) -> Node:
	var node = scene.instantiate()
	parent.add_child.call_deferred(node)
	# ↑ add_child后会立刻调用_ready，所以需要call_deferred
	return node

func generate_dialogue(dialogue : DialogueGroup) -> Control:
	var node := dialogue_ui.instantiate()
	node.dialogue = dialogue
	FixedContainer.add_child.call_deferred(node)
	return node

func apply_shake(strength : float, duration : float):
	GameManager.add_shake.emit(strength)
	get_tree().create_timer(duration).timeout.connect(func(): GameManager.add_shake.emit(-strength))

func generate_enemy(
	enemy : PackedScene,
	pos : Vector2,
	max_health : float,
	health : float,
	curve : Curve2D,
	speed_curve : Curve,
	interval : float,
	spell : PackedScene,
	count_dian : int,
	count_power : int,
	path_scale := Vector2(1, 1)) -> Array[Node2D]:#返回：[enemy, spell]
		var tmp : Node2D = enemy.instantiate()
		tmp.pos = pos
		tmp.set_deferred("max_health", max_health)
		tmp.set_deferred("health", health)
		tmp.curve = curve
		tmp.speed_curve = speed_curve
		tmp.interval = interval
		var tmp2 : Node2D
		if spell != null:
			tmp2 = ps(spell, tmp)
		else:
			tmp2 = null
		tmp.count_dian = count_dian
		tmp.count_power = count_power
		tmp.path_scale = path_scale
		EnemyPool.add_child(tmp)
		return [tmp, tmp2]
