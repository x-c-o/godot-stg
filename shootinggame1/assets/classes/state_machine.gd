extends Node
class_name StateMachine

func transition_state(v): pass
func tick(v): pass

var current_state : int = -1:
	set(v):
		transition_state(v)
		current_state = v

func _process(delta: float) -> void:
	#while true:
		#var next := owner.get_next_state() as int
		#if current_state == next:
			#break
		#current_state = next
	tick(delta)
