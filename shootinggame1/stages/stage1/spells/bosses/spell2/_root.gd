extends Node

var bullet := preload("res://stages/stage1/spells/bosses/spell2/bullet.tscn")
var bullet_2 := preload("res://stages/stage1/spells/bosses/spell2/bullet_2.tscn")
var eff_spell := preload("res://scenes/effects/eff_spell.tscn")
var eff_spell_label := preload("res://scenes/effects/eff_spell_label.tscn")
var F : BossRoot
var tween : Tween

var is_down : bool

func s1(val : float):
	if 0.1 < val and val < 0.4:
		for i in range(20):
			var tmp := GameManager.ps(bullet, GameManager.BulletPool)
			tmp.position = F.global_position
			tmp.v = Vector2(randf_range(-400.0, 400.0), randf_range(-1000.0, -400.0))
	if val > 0.34:
		if not is_down:
			var tw := create_tween()
			tw.tween_property(GameManager.MainStage, "effect_dash:material:shader_parameter/radius", 1.0, 0.5).from(0.0)
			GameManager.apply_shake(20.0, 0.2)
			var tw2 := create_tween()
			tw2.tween_property(Engine, "time_scale", 1.0, 0.5).from(0.2)
			is_down = true
			for i in range(61):
				var tmp := GameManager.ps(bullet_2, GameManager.BulletPool)
				#tmp.g = 0
				tmp.position = Vector2(F.global_position.x, 400.0)
				tmp.v = Vector2(150.0, 1000.0) * Vector2.from_angle(lerp(- PI, 0.0, i / 60.0))

func movement_init():
	tween = create_tween()
	tween.tween_property(F, "position", Vector2(0, -360), 1.0)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func movement_loop2():
	tween = create_tween()
	tween.tween_property(F, "position:x", GameManager.Player.position.x, 2.5)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.finished.connect(movement_loop)

func movement_loop():
	is_down = false
	tween = create_tween()
	tween.tween_property(F, "position:y", 360, 3.0)\
		.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_method(s1, 0.0, 1.0, 3.0)
	tween.tween_property(F, "position:y", -360, 3.0)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(movement_loop2)

func _ready():
	F.health = 800.0
	F.max_health = 800.0
	GameManager.ps(eff_spell, GameManager.EffectPool).spell_type="撃破"
	var eff := GameManager.ps(eff_spell_label, GameManager.FixedContainer)
	eff.spell_name="「單向標志」"
	movement_init()
	await get_tree().create_timer(2.0).timeout
	movement_loop()
	await F.foe_end
	tween.kill()
	eff.end()
	free()
