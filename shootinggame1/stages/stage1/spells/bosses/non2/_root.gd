extends Node

var spawner := preload("spawner.tscn")
var F : BossRoot
var tween : Tween

func movement_loop():
	tween = create_tween()
	tween.tween_property(F, "position", Vector2(randf_range(-200, 200), randf_range(-300, -200)), 2.0)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.finished.connect(movement_loop)

func _ready():
	F.health = 600.0
	F.max_health = 600.0
	await get_tree().create_timer(0.8).timeout
	var spawner1 = GameManager.ps(spawner, F)
	var spawner2 = GameManager.ps(spawner, F)
	spawner2.v_rot = 0.1
	spawner1.rect = Rect2(112, 32, 16, 16)
	spawner2.v_rot = -0.1
	spawner2.rect = Rect2(112, 80, 16, 16)
	movement_loop()
	await F.foe_end
	tween.kill()
	spawner1.free()
	spawner2.free()
	free()
