extends Node2D

var available := true
var spell := preload("res://scenes/player/player1/spell.tscn")

func cast_spell() -> void:
	for i in range(10):
		var tmp := spell.instantiate()
		tmp.position = global_position
		tmp.dir = TAU / 10.0 * i
		GameManager.SpellPool.add_child(tmp)

func cast() -> void:
	if available:
		available = false
		get_tree().create_timer(6.0).timeout.connect(func() : available = true)
		cast_spell()
		print("cast spell!!")
