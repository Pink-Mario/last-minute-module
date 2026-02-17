## Base class for individual states in a finite state machine.
##
## State represents a single behavior state (e.g., Idle, Walk, Attack, Jump).
## Extend this class and override enter(), exit(), update(), and update_physics()
## to define state-specific behavior. Emit the transition signal to switch states.
##
## @tutorial: Create a new script extending State, set state_name in the inspector,
## and add it as a child of a StateHandler node. Override virtual methods as needed.
extends Node
class_name State

## Unique identifier for this state. Used by StateHandler.get_state() for lookups.
@export var state_name: String = "Exist"

## Emit this signal with the target state_name to request a state transition.
signal transition(new_state: String)

## Reference to the Node2D that owns this state machine (set by StateHandler).
var user: Node2D
## Reference to the parent StateHandler managing this state.
var handler: StateHandler

## Called when entering this state. Override to initialize state-specific behavior.
func enter() -> void:
	pass

## Called when exiting this state. Override to clean up state-specific behavior.
func exit() -> void:
	pass

## Called every frame via _process. Override for frame-based logic (UI, timers, etc.).
func update(delta: float) -> void:
	pass

## Called every physics frame via _physics_process. Override for movement and physics logic.
func update_physics(delta: float) -> void:
	pass
