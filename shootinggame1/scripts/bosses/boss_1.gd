extends FoeRoot

#class_name BossRoot # TODO 分离成为一个类

var chara_name := "八雲　藍"

@onready var animation_player := $AnimationPlayer
@onready var health_bar := $HealthBar
var non1_spawner := preload("res://stages/stage1/spells/bosses/non1/root.tscn")
var spell1_spawner := preload("res://stages/stage1/spells/bosses/spell1/root.tscn")
var non2_spawner := preload("res://stages/stage1/spells/bosses/non2/root.tscn")
var spell2_bullet := preload("res://stages/stage1/spells/bosses/spell2/bullet.tscn")
var spell2_bullet_2 := preload("res://stages/stage1/spells/bosses/spell2/bullet_2.tscn")
var spell3_spawner := preload("res://stages/stage1/spells/bosses/spell3/root.tscn")
var eff_spell := preload("res://scenes/effects/eff_spell.tscn")
var eff_spell_label := preload("res://scenes/effects/eff_spell_label.tscn")
var eff_destroy := preload("res://scenes/effects/eff_destroy.tscn")
var dialogue1 := preload("res://assets/dialogues/dialogue1-1.tres")
var spawner : Node2D
var tween : Tween

var actions := [
	clear,
	conversation1,
	non1,
	spell1,
	non2,
	spell2,
	spell3,
	destroy
]

func non1_movement_loop():
	tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(randf_range(-200, 200), randf_range(-300, -200)), 2.0)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.finished.connect(non1_movement_loop)

func spell1_movement_loop():
	tween = get_tree().create_tween()
	tween.tween_property(self, "position", GameManager.Player.position, 4.0)\
		.set_trans(Tween.TRANS_CUBIC)
	tween.finished.connect(spell1_movement_loop)

func spell2_movement_init():
	tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(0, -360), 1.0)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

var spell2_is : bool # 要是能把符卡间独立开就好了

func spell2_s1(val : float):
	if 0.1 < val and val < 0.4:
		for i in range(20):
			var tmp := GameManager.ps(spell2_bullet, GameManager.BulletPool)
			tmp.position = global_position
			tmp.v = Vector2(randf_range(-400.0, 400.0), randf_range(-1000.0, -400.0))
	if val > 0.34:
		if not spell2_is:
			var tw := get_tree().create_tween()
			tw.tween_property(GameManager.MainStage, "effect:material:shader_parameter/radius", 1.0, 0.5).from(0.0)
			GameManager.apply_shake(20.0, 0.2)
			var tw2 := get_tree().create_tween()
			tw2.tween_property(Engine, "time_scale", 1.0, 0.5).from(0.2)
			spell2_is = true
			for i in range(61):
				var tmp := GameManager.ps(spell2_bullet_2, GameManager.BulletPool)
				#tmp.g = 0
				tmp.position = Vector2(global_position.x, 400.0)
				tmp.v = Vector2(150.0, 1000.0) * Vector2.from_angle(lerp(- PI, 0.0, i / 60.0))

func spell2_movement_loop2():
	tween = get_tree().create_tween()
	tween.tween_property(self, "position:x", GameManager.Player.position.x, 2.5)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.finished.connect(spell2_movement_loop)

func spell2_movement_loop():
	spell2_is = false
	tween = get_tree().create_tween()
	tween.tween_property(self, "position:y", 360, 3.0)\
		.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_method(spell2_s1, 0.0, 1.0, 3.0)
	tween.tween_property(self, "position:y", -360, 3.0)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(spell2_movement_loop2)

func spell3_movement_loop(duration := 3.0):
	var tmp := GameManager.ps(spell3_spawner, GameManager.BulletPool)
	tmp.position = position
	tmp.rotation = position.angle_to_point(GameManager.Player.position)
	await get_tree().create_timer(duration).timeout
	duration = max(duration, 0.5)
	tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(randf_range(-300, 300), randf_range(-300, -200)), 0.5)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.finished.connect(spell3_movement_loop.bind(duration - 0.4))

func _on_foe_end():
	if spawner != null:
		spawner.queue_free()
	tween.kill()
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

func non1():
	health = 600.0
	max_health = 600.0
	var spawner1 = GameManager.ps(non1_spawner, self)
	var spawner2 = GameManager.ps(non1_spawner, self)
	spawner2.v_rot = -0.2
	spawner2.rect = Rect2(160, 48, 16, 16)
	non1_movement_loop()
	await foe_end
	spawner1.queue_free()
	spawner2.queue_free()

func spell1():
	health = 800.0
	max_health = 800.0
	GameManager.ps(eff_spell, GameManager.EffectPool).spell_type="撃破"
	var eff := GameManager.ps(eff_spell_label, GameManager.FixedContainer)
	eff.spell_name="「通往殊途的倒數計時」"
	await get_tree().create_timer(2.0).timeout
	spawner = spell1_spawner.instantiate()
	add_child(spawner)
	spell1_movement_loop()
	await foe_end
	eff.end()

func non2():
	health = 600.0
	max_health = 600.0
	non1_movement_loop()
	await get_tree().create_timer(0.8).timeout
	var spawner1 = GameManager.ps(non2_spawner, self)
	var spawner2 = GameManager.ps(non2_spawner, self)
	spawner2.v_rot = 0.1
	spawner1.rect = Rect2(112, 32, 16, 16)
	spawner2.v_rot = -0.1
	spawner2.rect = Rect2(112, 80, 16, 16)
	await foe_end
	spawner1.queue_free()
	spawner2.queue_free()

func spell2():
	health = 800.0
	max_health = 800.0
	GameManager.ps(eff_spell, GameManager.EffectPool).spell_type="撃破"
	var eff := GameManager.ps(eff_spell_label, GameManager.FixedContainer)
	eff.spell_name="「單向標志」"
	spell2_movement_init()
	await get_tree().create_timer(2.0).timeout
	spell2_movement_loop()
	await foe_end
	eff.end()

func spell3():
	health = 1200.0
	max_health = 1200.0
	GameManager.ps(eff_spell, GameManager.EffectPool).spell_type="撃破"
	var eff := GameManager.ps(eff_spell_label, GameManager.FixedContainer)
	eff.spell_name="式神「仙狐思念」"
	await get_tree().create_timer(2.5).timeout
	spell3_movement_loop()
	await foe_end
	eff.end()

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
