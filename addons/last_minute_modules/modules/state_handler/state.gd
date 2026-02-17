extends Node
class_name State

@export var state_name: String = "Exist"

signal transition(new_state: State)

var user: Node2D
var handler: StateHandler

func enter() -> void:
	pass
func exit() -> void:
	pass

func update(delta: float) -> void:
	pass
func update_physics(delta: float) -> void:
	pass
