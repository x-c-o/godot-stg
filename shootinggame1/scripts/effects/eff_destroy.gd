extends Node2D

@onready var Sprite1 := $Sprite1
@onready var Sprite2 := $Sprite2

var maple := preload("res://scenes/effects/eff_maple.tscn")

func _ready() -> void:
	rotation = randf_range(0,TAU)
	Sprite1.scale = Vector2(1.0,1.0)
	Sprite2.scale = Vector2(0.0,0.0)
	Sprite1.modulate.a = 0.5
	Sprite2.modulate.a = 0.5
	for i in range(8):
		var tmp := maple.instantiate()
		add_child(tmp)

func _process(delta: float) -> void:
	Sprite1.scale.x += (0.3 - Sprite1.scale.x) * 0.1
	Sprite1.scale.y += (2.5 - Sprite1.scale.y) * 0.1
	Sprite2.scale.x += (1.5 - Sprite2.scale.x) * 0.1
	Sprite2.scale.y += (1.5 - Sprite2.scale.y) * 0.1
	Sprite1.modulate.a -= delta
	Sprite2.modulate.a -= delta
	if get_child_count() == 2 and Sprite1.modulate.a <= 0.0:
		queue_free()
