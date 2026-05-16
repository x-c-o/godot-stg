extends Node

var laser := preload("laser.tscn")
var eff_spell := preload("res://scenes/effects/eff_spell.tscn")
var eff_spell_label := preload("res://scenes/effects/eff_spell_label.tscn")
var F : BossRoot
var tween : Tween

func movement_loop():
	var vec := 30.0 * (GameManager.Player.position - F.position).normalized()
	for i in range(3):
		var tmp := GameManager.ps(laser, GameManager.BulletPool)
		tmp.pos = F.position
		tmp.bounce = vec.rotated(remap(i + 0.5, 0, 3, -PI, PI))
	#var tw := create_tween()
	#tw.tween_property(GameManager.MainStage, "effect_underwater:material:shader_parameter/warp", 0.0, 2.0).from(5.0)
	#tw.parallel().tween_property(GameManager.MainStage, "effect_greyscale:material:shader_parameter/ratio", 0.0, 2.0).from(1.0)
	tween = create_tween()
	tween.tween_property(F, "position", Vector2(randf_range(-200, 200), randf_range(-300, -200)), 1.5)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.finished.connect(movement_loop)

func _ready():
	F.health = 800.0
	F.max_health = 800.0
	GameManager.ps(eff_spell, GameManager.EffectPool).spell_type="撃破"
	var eff := GameManager.ps(eff_spell_label, GameManager.FixedContainer)
	eff.spell_name="光障「避彈不能的曲線激光」"
	await get_tree().create_timer(2.5).timeout
	movement_loop()
	await F.foe_end
	tween.kill()
	eff.end()
	free()
