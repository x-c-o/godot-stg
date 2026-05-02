extends Node2D

@export var spell_type : String

@onready var label := $Type/TypeLabel

func _ready() -> void:
	label.text = spell_type
