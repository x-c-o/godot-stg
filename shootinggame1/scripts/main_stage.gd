extends Node2D

const origin := Vector2(420, 500)
const center := Vector2(640, 480)

@export var lt := Vector2(360, 400)
@export var rb := Vector2(360, 400)
@export var pivot := origin
@export var item_get_height := 250

@onready var background := $Background
@onready var player := $Game/Player
@onready var mask := $Mask/PanelContainer
@onready var color_rect := $CanvasLayer/Board
@onready var camera := $Game/Camera2D
@onready var effect := $CanvasLayer/Effect
@onready var boss_health_bar := $BossHealthBar

@onready var PlayerBulletPool := $Game/PlayerBulletPool
@onready var BulletPool := $Game/BulletPool
@onready var EnemyPool := $Game/EnemyPool
@onready var EffectPool := $Game/EffectPool
@onready var ItemPool := $Game/ItemPool
@onready var BossPool := $Game/BossPool
@onready var SpellPool := $Game/SpellPool
@onready var FixedContainer := $GameUI/FixedContainer
@onready var ItemGetBorderLine := $Game/EffectPool/ItemGetBorderLine

@onready var game_bg_texture := $GameBG/GameBGTexture
@onready var board_material : ShaderMaterial = $CanvasLayer/Board.material

var camera_shake : float

func update_layout():
	ItemGetBorderLine.position = Vector2(0, item_get_height - lt.y)
	game_bg_texture.position = pivot - center
	mask.position = pivot - lt
	mask.size = lt + rb
	player.lt = origin - pivot + lt
	player.rb = pivot - origin + rb
	FixedContainer.position = pivot - lt
	FixedContainer.size = lt + rb

func _ready() -> void:
	GameManager.MainStage = self
	GameManager.PlayerBulletPool = PlayerBulletPool
	GameManager.BulletPool = BulletPool
	GameManager.EffectPool = EffectPool
	GameManager.EnemyPool = EnemyPool
	GameManager.ItemPool = ItemPool
	GameManager.BossPool = BossPool
	GameManager.SpellPool = SpellPool
	GameManager.FixedContainer = FixedContainer
	GameManager.add_shake.connect(_on_add_shake)
	camera.offset = center - pivot
	update_layout()
	player.position = Vector2(0, 300)

func _process(_delta: float) -> void:
	if player.position.y < ItemGetBorderLine.position.y:
		GameManager.all_item_collect.emit()
	board_material.set_shader_parameter("camera_offset",
		camera_shake * Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)))
	#var ss = sin(Time.get_ticks_msec() * 0.001)
	#var cc = sin(Time.get_ticks_msec() * 0.001)
	#lt = Vector2(360 + 100 * ss, 400 + 100 * cc)
	#rb = Vector2(360 + 100 * ss, 400 + 100 * cc)
	#pivot = Vector2(420 + cc * 500, 420)
	#update_layout()

func _on_add_shake(strength : float):
	camera_shake += strength
