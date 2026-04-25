extends Node2D

var speed : float
var speed_vec : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = randf_range(0.2,0.8)
	var tmp := randf_range(0,TAU)
	speed_vec = randf_range(200,500) * Vector2(cos(tmp),sin(tmp))
	rotation = randf_range(0,TAU)
	tmp = randf_range(0.2,1.0)
	scale = Vector2(tmp, tmp)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	modulate.a -= delta
	if modulate.a <= 0.0:
		queue_free()
		return
	rotation += 15 * delta
	position += delta * speed_vec
	#modulate.a -= delta
