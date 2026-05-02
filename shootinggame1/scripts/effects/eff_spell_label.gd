extends Control

@export var spell_name : String

@onready var label := $TextureRect/Label
@onready var ap := $AnimationPlayer

func end():
	ap.play("break")

func _ready() -> void:
	label.text = spell_name
