extends Area2D

class_name BulletRoot

var break_effect := preload("res://scenes/effects/eff_break.tscn")
var graze_effect := preload("res://scenes/effects/eff_graze.tscn")

func ready(): pass

func dis_pow2(a : Vector2, b : Vector2) -> float:
	return (a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y)

func _on_bullet_clear():
	var tmp := break_effect.instantiate()
	tmp.position = global_position
	GameManager.EffectPool.add_child(tmp)
	queue_free()

func _on_bullet_clear_point(point : Vector2, radius : float):
	if dis_pow2(position, point) <= radius * radius:
		_on_bullet_clear()

func graze():
	var tmp = graze_effect.instantiate()
	tmp.position = global_position
	GameManager.EffectPool.add_child(tmp)

func _ready() -> void:
	collision_layer = 2 # 敌弹
	collision_mask = 32 + 128 # 自机 Spell，自机擦弹
	GameManager.bullet_clear.connect(_on_bullet_clear)
	GameManager.bullet_clear_point.connect(_on_bullet_clear_point)
	area_entered.connect(_on_area_entered)
	ready()

func _on_area_entered(area: Area2D) -> void:
	match area.collision_layer:
		32:
			_on_bullet_clear()

# 该类需要：
# 开始时注册消弹事件
# 擦弹函数
# 初始化collision_layer
# 似乎没有了
