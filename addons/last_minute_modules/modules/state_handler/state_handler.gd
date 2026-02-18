## A finite state machine (FSM) controller that manages State transitions.
##
## StateHandler coordinates multiple State child nodes, handling transitions
## and routing _process/_physics_process calls to the active state.
## It automatically discovers all State children and connects their transition signals.
##
## @tutorial: Add State nodes as children, then call start() with the owner Node2D
## and initial state from your character's _ready() function.
extends Node
class_name StateHandler

## The Node2D that owns this state machine (typically the character/enemy).
var user: Node2D
## All registered State children discovered on start().
var states: Array[State]
## The currently active state receiving update calls.
var current_state: State

## Initializes the state machine with an owner and starting state.
## Must be called before the FSM will process states.
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
	if not new_state or new_state == current_state:
		return
	
	current_state.exit()
	current_state = new_state
	current_state.enter()
	
func force_state(new_state: State) -> void:
	current_state = new_state
	current_state.enter()
