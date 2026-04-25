extends Node2D

@export var rotate_speed := 1.0

@onready var border_sprite_1: Sprite2D = $BorderSprite1
@onready var border_sprite_2: Sprite2D = $BorderSprite2

func _ready() -> void:
	scale = Vector2(2.0, 2.0)
	modulate = Color.TRANSPARENT

func show_border():
	scale += (Vector2(1.0, 1.0) - scale) * 0.3
	modulate += (Color.from_rgba8(255, 255, 255, 150) - modulate) * 0.2

func hide_border():
	scale += (Vector2(2.0, 2.0) - scale) * 0.2
	modulate += (Color.TRANSPARENT - modulate) * 0.4

func _process(delta: float) -> void:
	border_sprite_1.rotation += rotate_speed * delta
	border_sprite_2.rotation -= rotate_speed * delta
