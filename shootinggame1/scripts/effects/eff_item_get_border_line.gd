extends Line2D

@onready var label := $Label

var interval := 0.0

func _ready() -> void:
	modulate.a = 0

func _process(delta: float) -> void:
	interval += delta
	if interval < 1.0:
		modulate.a = min(modulate.a + delta, 1.0)
	if interval > 2.0:
		modulate.a -= 0.5 * delta
