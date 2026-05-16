extends FoeRoot

class_name BossRoot # TODO 分离成为一个类

var chara_name := "八雲　藍"

func apply_spell(spell : Script, F := self) -> Node:
	var s : Node = spell.new()
	s.F = F
	add_child(s)
	return s

@onready var animation_player := $AnimationPlayer
@onready var health_bar := $HealthBar
var non1 := preload("res://stages/stage1/spells/bosses/non1/_root.gd")
var non2 := preload("res://stages/stage1/spells/bosses/non2/_root.gd")
var spell1 := preload("res://stages/stage1/spells/bosses/spell1/_root.gd")
var spell2 := preload("res://stages/stage1/spells/bosses/spell2/_root.gd")
var spell3 := preload("res://stages/stage1/spells/bosses/spell3/_root.gd")
var spell4 := preload("res://stages/stage1/spells/bosses/spell4/_root.gd")
var eff_destroy := preload("res://scenes/effects/eff_destroy.tscn")
var dialogue1 := preload("res://assets/dialogues/dialogue1-1.tres")
var laser1 := preload("res://scenes/danmaku/danmaku_curve_laser.tscn")

var actions := [
	#debug,
	#clear,
	conversation1,
	apply_spell.bind(non1),
	apply_spell.bind(spell1),
	apply_spell.bind(non2),
	apply_spell.bind(spell2),
	apply_spell.bind(spell3),
	apply_spell.bind(spell4),
	destroy
]

func debug():
	var tmp := load("res://scenes/danmaku/danmaku_curve_laser.tscn")
	GameManager.ps(tmp, GameManager.BulletPool)

func _on_foe_end():
	GameManager.bullet_clear.emit()
	await get_tree().create_timer(0.5).timeout
	current_action += 1

func clear():
	GameManager.bullet_clear.emit()
	current_action += 1

func update_health():
	if health_bar.value > 0.0 and health <= 0.0:
		foe_end.emit()
		print("FOE END")
	health_bar.max_value = max_health
	health_bar.value = health
	GameManager.MainStage.boss_health_bar.upd()

func appear():# 出現的同時綁定到血條
	GameManager.MainStage.boss_health_bar.source = self
	animation_player.play("appear")

func conversation1():
	var ui := GameManager.generate_dialogue(dialogue1)
	ui.dialogue_end.connect(func():
		await get_tree().create_timer(1.0).timeout
		current_action += 1
		animation_player.pause())
	ui.dialogue_call.connect(func(): appear())

func destroy():# 擊敗的同時解綁血條
	GameManager.MainStage.boss_health_bar.source = null
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
