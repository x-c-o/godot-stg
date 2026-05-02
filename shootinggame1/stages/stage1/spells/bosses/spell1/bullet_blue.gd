extends BulletRoot

@onready var sprite := $Sprite2D

@export var dir := 0.0
@export var speed := 500.0
var speed_vec : Vector2
var dir_change := 0.0
var _speed := 0.0
var bounce := 0.0
var dis := 0.0
var tdis := 0.0

func _process(delta: float) -> void:
	rotation = dir + dir_change
	_speed += delta * 0.8
	var tmp = 5.0 * (1 - _speed + floor(_speed))
	position += tmp * Vector2.from_angle(rotation)
	tdis += tmp
	bounce = bounce * 0.93 + (tdis - dis) * 0.1
	dis += bounce
	sprite.scale.x = 1.0 + bounce / 20.0
	sprite.scale.y = 1.0 - bounce / 50.0
	if GameManager.out_of_stage(position):
		queue_free()

#func _ready() -> void:
	#_speed = speed

#func _process(delta: float) -> void:
	#_speed = abs(speed)
	#rotation = dir + dir_change
	#speed_vec = Vector2(cos(rotation),sin(rotation))
	#position += speed_vec * _speed * delta
	#dir_change = min(dir_change + _speed * 0.005 * delta, PI / 2)
	#tdis += _speed
	#bounce = bounce * 0.93 + (tdis - dis) * 0.1
	#dis += bounce
	#speed -= 15.0
	#sprite.scale.x = 1.0 + bounce / 1000.0
	#sprite.scale.y = 1.0 - bounce / 5000.0
