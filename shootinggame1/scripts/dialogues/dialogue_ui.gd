extends Node

signal dialogue_call
signal dialogue_end

@export_group("UI")
@export var character_name_text : Label
@export var text_box : Label
@export var avaters : Array[TextureRect]

@export_group("Dialogue")
@export var dialogue : DialogueGroup

@onready var animation_player := $AnimationPlayer
@onready var panel := $Panel

var current_index := 0
var current_dialogue
var current_tachie := 0
var is_holding := false
var typing_tween : Tween
var is_end := false

func append(x : String):
	text_box.text += x

func display_dialogue(idx : int):
	if typing_tween and typing_tween.is_running():
		typing_tween.kill()
		text_box.text = current_dialogue.content
		return
	if idx == dialogue.dialogue_list.size():
		if not is_end:
			is_end = true
			dialogue_end.emit()
			animation_player.play("hide")
		return
	while dialogue.dialogue_list[idx].content == "CALL":
		dialogue_call.emit()
		idx += 1
	current_dialogue = dialogue.dialogue_list[idx]
	typing_tween = get_tree().create_tween()
	text_box.text = ""
	for i in current_dialogue.content:
		typing_tween.tween_callback(append.bind(i)).set_delay(0.05)
	character_name_text.text = current_dialogue.character_name
	current_tachie = current_dialogue.character_number
	if current_tachie != -1:
		avaters[current_tachie].texture = current_dialogue.tachie
	current_index = idx + 1

func _ready() -> void:
	display_dialogue(current_index)

var interval := 0.0

func _process(delta: float) -> void:
	interval += delta
	panel.position = Vector2(8.0 * sin(0.7 * interval + 0.2), 448.0 + 8.0 * sin(1.0 * interval))
	panel.rotation = 0.02 * sin(0.7 * interval)
	if Input.get_action_strength("shoot"):
		if not is_holding:
			is_holding = true
			display_dialogue(current_index)
	else:
		is_holding = false
	for i in avaters.size():
		if i == current_tachie:
			avaters[i].anim_show()
		else:
			avaters[i].anim_hide()
