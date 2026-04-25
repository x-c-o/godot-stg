extends TextureRect

@export var pos_init := Vector2(0.0,0.0)
@export var pos_hide := Vector2(0.0,0.0)
@export var pos_show := Vector2(0.0,0.0)

var shown := false

func _ready() -> void:
	position = pos_init
	modulate = Color.TRANSPARENT

func anim_show():
	shown = true
	modulate += (Color.WHITE - modulate) * 0.2
	position += (pos_show - position) * 0.2

func anim_hide():
	if shown:
		modulate += (Color.from_hsv(0.0,0.0,0.2,0.5) - modulate) * 0.2
		position += (pos_hide - position) * 0.2
