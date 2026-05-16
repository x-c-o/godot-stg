extends BulletRoot

var bullet := preload("bullet.tscn")
@onready var speed_vec := 800.0 * Vector2.from_angle(rotation)
var interval := 0.0

var poses :=[
	[[0.0, 1.0], [0.0, -1.0], [1.0, 0.0], [-1.0, 0.0]],
	[[0.0, 2.0], [0.0, -2.0], [2.0, 0.0], [-2.0, 0.0], [-1.0, 1.0], [1.0, 1.0], [1.0, -1.0], [-1.0, -1.0]],
	[[0.0, 3.0], [1.0, 2.0], [2.0, 1.0], [3.0, 0.0], [2.0, -1.0], [1.0, -2.0], [0.0, -3.0], [-1.0, -2.0], [-2.0, -1.0], [-3.0, 0.0], [-2.0, 1.0], [-1.0, 2.0]],
]

var rects :=[
	Rect2(224, 144, 16, 16),
	Rect2(224, 160, 16, 16),
	Rect2(224, 176, 16, 16)
]

func gene(pos, rect):
	for i in range(8):
		var tmp = GameManager.ps(bullet, GameManager.BulletPool)
		tmp.position = pos
		tmp.rotation = rotation + TAU / 8 * i
		tmp.rect = rect

func disa():
	$CollisionShape2D.set_deferred("disabled", true)
	var tw := get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tw.tween_property(self, "modulate:a", 0.0, 0.5)
	tw.parallel().tween_property(self, "scale", Vector2(2.0, 2.0), 0.5)
	tw.finished.connect(queue_free)

func koishi():
	disa()
	var pos := position
	var vec := speed_vec.normalized()
	speed_vec = Vector2.ZERO
	for i in range(3):
		for j in range(poses[i].size()):
			gene(pos + 64.0 * (poses[i][j][0] * vec + poses[i][j][1] * vec.rotated(PI / 2)), rects[i])
		await get_tree().create_timer(0.1).timeout

func _process(delta):
	interval += delta
	position += delta * speed_vec
	if interval >= 0.3:
		interval = -100000.0
		koishi()
