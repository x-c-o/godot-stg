extends Area2D

@export var damage := 1.0

var effect := preload("res://scenes/effects/eff_splash.tscn")

func _process(delta: float) -> void:
	position.y -= delta * 2500
	if GameManager.out_of_stage(position):
		queue_free()

func hit() -> void:
	var tmp = effect.instantiate()
	tmp.position = position
	GameManager.EffectPool.add_child(tmp)
	queue_free()
