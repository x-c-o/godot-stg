extends Node2D

@export var spell_name : String

@onready var label := $Name/NameLabel

func _ready() -> void:
	#label.text = spell_name
	pass

var interval := 0.0
func _process(delta: float) -> void:
	interval += delta
	label.material.set_shader_parameter("ratio", randf_range(0.0, 1.0))
