extends Control

@onready var score_label : Label = $Container/ScoreLabel
@onready var power_label : Label = $Container/PowerLabel
@onready var fps_label : Label = $Container/FPSLabel

func _on_player_power_changed(power: float, max_power: float) -> void:
	power_label.text = "Power：" + ("%0.2f" % power) + " / " + ("%0.2f" % max_power)

func _on_player_score_changed(value: int) -> void:
	score_label.text = "得点：" + var_to_str(value)

func _process(_delta: float) -> void:
	fps_label.text = "FPS：" + var_to_str(Engine.get_frames_per_second())
