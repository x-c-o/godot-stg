extends BulletRoot
class_name DanmakuLaser

@onready var line : Line2D = $Line2D
@onready var shape_cast := $ShapeCast2D
const laser_width_curve = preload("res://assets/curves/laser_width.tres")

func tick(delta : float): pass

var laser_lifetime : int = 20
var laser_width : float = 20.0

func ready() -> void:
	print("LINE : ", line)
	line.width = laser_width

func laser_add_point(p : Vector2):
	line.add_point(p)
	if(line.get_point_count() > laser_lifetime):
		line.remove_point(0)

func check_laser_hits():
	for i in range(line.points.size() - 1):
		var from := line.points[i]
		var to := line.points[i + 1]
		shape_cast.shape.radius = laser_width * laser_width_curve.sample((float(i) + 0.5) / line.points.size())
		shape_cast.position = from
		shape_cast.target_position = to - from
		shape_cast.force_shapecast_update()
		if shape_cast.is_colliding():
			shape_cast.get_collider(0).area_entered.emit(self)

var pos : Vector2
var bounce : Vector2

var interval := 0.0

func _process(delta: float) -> void:
	tick(delta)
	check_laser_hits()
