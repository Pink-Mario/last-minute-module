extends Node
class_name StateHandler

var user: Node2D

var states: Array[State]
var current_state: State

func start(user: Node2D, intital_state: State):
	for state in get_children():
		if not state is State: continue
		states.append(state)
		state.connect("transition", trigger_transition)
	current_state = intital_state

func _process(delta: float) -> void:
	if not current_state: return
	current_state.update()

func _physics_process(delta: float) -> void:
	if not current_state: return
	current_state.update_physics()

func trigger_transition(new_state: State):
	if new_state == current_state:
		return
