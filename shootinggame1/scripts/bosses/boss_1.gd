extends FoeRoot

#class_name BossRoot # TODO 分离成为一个类

@onready var animation_player := $AnimationPlayer
@onready var health_bar := $HealthBar
var spell1_spawner := preload("res://stages/stage1/spells/bosses/spell1/root.tscn")
var eff_spell := preload("res://scenes/effects/eff_spell.tscn")
var eff_destroy := preload("res://scenes/effects/eff_destroy.tscn")
var dialogue1 := preload("res://assets/dialogues/dialogue1-1.tres")
var spawner : Node2D

var actions := [
	clear,
	conversation1,
	spell1,
	destroy
]

func _on_foe_end():
	if spawner != null:
		spawner.queue_free()
	GameManager.bullet_clear.emit()
	await get_tree().create_timer(1.0).timeout
	current_action += 1

func clear():
	GameManager.bullet_clear.emit()
	current_action += 1

func update_health():
	if health_bar.value > 0.0 and health <= 0.0:
		foe_end.emit()
	health_bar.max_value = max_health
	health_bar.value = health

func appear():
	animation_player.play("appear")

func conversation1():
	var ui := GameManager.generate_dialogue(dialogue1)
	ui.dialogue_end.connect(func():
		await get_tree().create_timer(1.0).timeout
		current_action += 1)
	ui.dialogue_call.connect(func(): appear())

func spell1():
	health = 800.0
	max_health = 800.0
	GameManager.ps(eff_spell, GameManager.EffectPool)
	await get_tree().create_timer(2.0).timeout
	spawner = spell1_spawner.instantiate()
	add_child(spawner)

func destroy():
	var tmp := eff_destroy.instantiate()
	tmp.position = global_position
	GameManager.EffectPool.add_child(tmp)
	SFXManager.se_enep00.play()
	queue_free()

var current_action : int:
	set(v):
		current_action = v
		actions[v].call()

func _ready() -> void:
	health = 10000.0
	position.x = 10000.0
	collision_layer = 8
	collision_mask = 16 + 32
	sprite = $Sprite
	current_action = 0

func tick(delta: float) -> void:
	pass
	#position.x += (GameManager.Player.position.x - position.x) * 0.02
