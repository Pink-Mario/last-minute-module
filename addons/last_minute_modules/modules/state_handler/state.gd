extends Node
class_name State

@export var state_name = "Exist"

signal transition(new_state: State)

# actually trying state machines for once lol
func enter():
	pass

func exit():
	pass

func update():
	pass

func update_physics():
	pass
