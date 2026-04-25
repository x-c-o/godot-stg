extends AnimatedSprite2D

func _on_animation_finished() -> void:
	if animation == "turn_left":
		play("hold_left")
	elif animation == "turn_right":
		play("hold_right")
	elif animation == "turn_left_rev":
		play("idle_left")
	elif animation == "turn_right_rev":
		play("idle_right")
