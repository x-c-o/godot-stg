extends AnimatedSprite2D

func _on_animation_finished() -> void:
	if animation == "turn":
		play("hold")
	else:
		scale.x = 1
		play("idle")
