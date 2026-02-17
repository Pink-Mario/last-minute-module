extends Node
class_name StateHandler

var user: Node2D
var states: Array[State]
var current_state: State

func start(owner: Node2D, initial_state: State) -> void:
	user = owner
	for state in get_children():
		if not state is State:
			continue
		states.append(state)
		state.handler = self
		state.user = user
		state.transition.connect(trigger_transition)
	
	current_state = initial_state
	current_state.enter()

func _process(delta: float) -> void:
	if not current_state:
		return
	current_state.update(delta)

func _physics_process(delta: float) -> void:
	if not current_state:
		return
	current_state.update_physics(delta)

func trigger_transition(new_state: State) -> void:
	if new_state == current_state:
		return
	current_state.exit()
	current_state = new_state
	current_state.enter()

func get_state(state_name: String) -> State:
	for state in states:
		if state.state_name == state_name:
			return state
	push_warning("StateHandler: no state found with name " + state_name)
	return null

func force_state(new_state: State) -> void:
	current_state = new_state
	current_state.enter()
