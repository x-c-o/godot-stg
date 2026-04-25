extends Node2D

@export var Player : Node2D
var Bullet := preload("bullet.tscn")
var bullet

func _ready() -> void:
	bullet = Bullet.instantiate()
	bullet.Player = Player
	add_child(bullet)
