extends Node

var spawner := preload("spawner.tscn")
var eff_spell := preload("res://scenes/effects/eff_spell.tscn")
var eff_spell_label := preload("res://scenes/effects/eff_spell_label.tscn")
var F : BossRoot
var tween : Tween

func movement_loop():
	tween = create_tween()
	tween.tween_property(F, "position", GameManager.Player.position, 4.0)\
		.set_trans(Tween.TRANS_CUBIC)
	tween.finished.connect(movement_loop)

func _ready():
	F.health = 800.0
	F.max_health = 800.0
	GameManager.ps(eff_spell, GameManager.EffectPool).spell_type="撃破"
	var eff := GameManager.ps(eff_spell_label, GameManager.FixedContainer)
	eff.spell_name="「通往殊途的倒數計時」"
	await get_tree().create_timer(2.0).timeout
	var spawner = spawner.instantiate()
	F.add_child(spawner)
	movement_loop()
	await F.foe_end
	eff.end()
	tween.kill()
	spawner.free()
	free()
