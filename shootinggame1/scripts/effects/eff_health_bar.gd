extends Control

var tween : Tween
var tween2 : Tween

@export var source : Node:
	set(v):
		source = v
		if tween != null:
			tween.kill()
		tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		if v != null:
			l_name.text = v.chara_name
			tween.tween_property(self, "scale:y", 1.0, 1.0).from_current()
		else:
			tween.tween_property(self, "scale:y", 0.0, 1.0).from_current()
		#print("SOURCE : ", source)
		upd()

@onready var rect := $A/B/ColorRect
@onready var l_name := $A/B/C/Name
@onready var l_val := $A/B/C/Val
@onready var text : String:
	set(v):
		text = v
		l_name.text = v
@onready var ratio : float:
	set(v):
		ratio = v
		var dis = max(781.0 * v, l_val.get_rect().size.x + 76.0)
		#print(dis,"    ", l_name.get_rect().size.x)
		if dis - 150.0 > l_name.get_rect().size.x :
			if is_name_hide:
				is_name_hide = false
				if tween2 != null: tween2.kill()
				tween2 = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
				tween2.tween_property(l_name, "modulate:a", 1.0, 0.5)
		else:
			if not is_name_hide:
				is_name_hide = true
				if tween2 != null: tween2.kill()
				tween2 = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
				tween2.tween_property(l_name, "modulate:a", 0.0, 0.5)
		l_val.offset_right = min(-781.0 + dis, 0.0)
		rect.material.set_shader_parameter("ratio", max(v, 0.05))

var is_name_hide := false

func upd():
	#print("UPD!")
	if source != null:
		l_val.text = str(max(0, int(source.health)))# 先設置text再設置ratio，因為需要text的width
		#print(source.health," / ",source.max_health, "    ",l_val.text,", ", l_val.get_rect().size.x)
		ratio = source.health / source.max_health
		#print(l_val.offset_right)
