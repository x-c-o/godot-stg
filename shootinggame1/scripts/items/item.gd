extends Area2D

@export var ID : String

var speed := -300.0
var bounce := 0.0
var is_following := false
var follow_speed := 0.0

func start_follow():
	GameManager.all_item_collect.disconnect(start_follow) # 出于性能考虑
	is_following = true

func _ready() -> void:
	GameManager.all_item_collect.connect(start_follow)

func follow_player(delta : float):
	var tmp := position.distance_to(GameManager.Player.position)
	if tmp < GameManager.Player.current_item_get_radius:
		is_following = true
	if is_following:
		follow_speed += 40 * delta
		position += minf(follow_speed / tmp, 1.0) * (GameManager.Player.position - position)	

func _process(delta: float) -> void:
	if GameManager.in_death_area_down(position):
		queue_free()
	position.y += delta * speed
	follow_player(delta)
	if speed + 10.0 < 150:
		speed += 10.0
		rotation += delta * 15 * PI
	else:
		speed = 150.0
		rotation = 0
