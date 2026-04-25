extends Node

enum LevelState{
	STAGE_NORMAL,
	STAGE_MID_BOSS,
	STAGE_NORMAL_2,
	STAGE_BOSS_DIALOGUE,
	STAGE_BOSS
}

var current_state : int = -1:
	set(v):
		transition_state(v)
		current_state = v
var state_time := 0.0

var enemy1 := preload("res://scenes/enemies/enemy.tscn")
var boss1 := preload("res://scenes/bosses/boss1.tscn")
var curve0 := preload("res://assets/curves/curve0.tres")
var curve1 := preload("res://assets/curves/curve1.tres")
var curve2 := preload("res://assets/curves/curve2.tres")
var curve3 := preload("res://assets/curves/curve3.tres")
var speed_curve0 := preload("res://assets/curves/speed_curve0.tres")
var speed_curve1 := preload("res://assets/curves/speed_curve1.tres")
var speed_curve2 := preload("res://assets/curves/speed_curve2.tres")
var spell1 := preload("res://stages/stage1/spells/enemies/spell1/Root.tscn")
var spell2 := preload("res://stages/stage1/spells/enemies/spell2/Root.tscn")
var spell3 := preload("res://stages/stage1/spells/enemies/spell3/Root.tscn")
var spell4 := preload("res://stages/stage1/spells/enemies/spell4/Root.tscn")
var spell5 := preload("res://stages/stage1/spells/enemies/spell5/Root.tscn")

var waves_normal := [
	[1.0, func():
		for i in range(10):
			GameManager.generate_enemy(enemy1, Vector2(0, 0), 10, 10, curve0, speed_curve0, 8, spell1, 4, 4)
			await get_tree().create_timer(0.3).timeout
		],
	[8.0, func():
		GameManager.bullet_clear.emit()
		GameManager.enemy_clear.emit()
		],
	[11.0, func():
		for i in range(5):
			GameManager.generate_enemy(enemy1, Vector2(0, -100), 50, 50, curve1, speed_curve1, 5, spell1,4 ,0)
			await get_tree().create_timer(0.2).timeout
		],
	[16.0, func():
		GameManager.bullet_clear.emit()
		for i in range(5):
			GameManager.generate_enemy(enemy1, Vector2(0, -100), 50, 50, curve1, speed_curve1, 5, spell1, 0, 4, Vector2(-1, 1))
			await get_tree().create_timer(0.2).timeout
		],
	[21.0, func():
		GameManager.bullet_clear.emit()
		for i in range(8):
			var tmp := GameManager.generate_enemy(enemy1, Vector2(0, 0), 10, 10, curve2, speed_curve1, 5, spell2, 1, 0)
			tmp[1].start_color = i * 0.05
			await get_tree().create_timer(0.3).timeout
		],
	[26.0, func():
		for i in range(8):
			var tmp := GameManager.generate_enemy(enemy1, Vector2(0, 0), 10, 10, curve2, speed_curve1, 5, spell2, 0, 1, Vector2(-1, 1))
			tmp[1].start_color = 0.5 + i * 0.05
			await get_tree().create_timer(0.3).timeout
		],
	[32.0, func():
		GameManager.generate_enemy(enemy1, Vector2(0, 0), 100, 100, curve3, speed_curve2, 11, spell3, 5, 5)
		],
	[45.0, func():
		GameManager.generate_enemy(enemy1, Vector2(0, -200), 50, 50, curve1, speed_curve1, 5, spell4, 3, 3)
		GameManager.generate_enemy(enemy1, Vector2(0, -200), 50, 50, curve1, speed_curve1, 5, spell4, 3, 3, Vector2(-1, 1))
		],
	#[52.0, func():
		#GameManager.generate_enemy(enemy1, Vector2(0, 0), 100, 100, curve3, speed_curve2, 11, spell5, 5, 5)
		#var tmp := GameManager.generate_enemy(enemy1, Vector2(0, 0), 100, 100, curve3, speed_curve2, 11, spell5, 5, 5, Vector2(-1, -1))
		#tmp[1].sprite_idx = 5
		#],
	[52.0, func():
		GameManager.enemy_clear.emit()
		],
]

var waves : Array;
var current_wave := 0

func _ready() -> void:
	await owner.ready
	await get_tree().create_timer(1.0).timeout # for DEBUG
	current_state = 0

func transition_state(v):
	current_wave = 0
	match v:
		LevelState.STAGE_NORMAL:
			state_time = 0.0
			waves = waves_normal
		LevelState.STAGE_MID_BOSS:
			GameManager.BossPool.add_child(boss1.instantiate())
		# 其他的会加

func _process(delta: float) -> void:
	match current_state:
		LevelState.STAGE_NORMAL, LevelState.STAGE_NORMAL_2:
			state_time += delta
			if current_wave == waves.size():
				current_state += 1
			elif state_time >= waves[current_wave][0]:
				waves[current_wave][1].call()
				current_wave += 1
