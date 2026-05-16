extends DanmakuLaser

func tick(delta : float):
	interval += delta
	if interval < 3.0:
		laser_add_point(pos)
		bounce = bounce * 0.97 + (GameManager.Player.position - pos) * 0.005
		pos += bounce * 60.0 * delta
	else:
		if line.points.is_empty():
			queue_free()
			return
		line.remove_point(0)
	if GameManager.in_death_area_down(pos, 0.0) or GameManager.in_death_area_up(pos, 0.0):
		bounce.y *= -1
	if GameManager.in_death_area_left(pos, 0.0) or GameManager.in_death_area_right(pos, 0.0):
		bounce.x *= -1
