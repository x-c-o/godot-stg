extends Node

var spawner := preload("spawner.tscn")
var eff_spell := preload("res://scenes/effects/eff_spell.tscn")
var eff_spell_label := preload("res://scenes/effects/eff_spell_label.tscn")
var F : BossRoot
var tween : Tween

func movement_loop(duration := 3.0):
	var tmp := GameManager.ps(spawner, GameManager.BulletPool)
	tmp.position = F.position
	tmp.rotation = F.position.angle_to_point(GameManager.Player.position)
	await get_tree().create_timer(duration).timeout
	duration = max(duration, 0.5)
	tween = create_tween()
	tween.tween_property(F, "position", Vector2(randf_range(-300, 300), randf_range(-300, -200)), 0.5)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.finished.connect(movement_loop.bind(duration - 0.4))

func _ready():
	F.health = 1200.0
	F.max_health = 1200.0
	GameManager.ps(eff_spell, GameManager.EffectPool).spell_type="撃破"
	var eff := GameManager.ps(eff_spell_label, GameManager.FixedContainer)
	eff.spell_name="式神「仙狐思念」"
	await get_tree().create_timer(2.5).timeout
	movement_loop()
	await F.foe_end
	tween.kill()
	eff.end()
	free()
