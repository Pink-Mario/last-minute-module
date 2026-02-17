## Base class for pathfinding modules
##
## Contains shared functionality for all pathfinding types.
## Extend this class to create specialized pathfinding behaviors.

extends Node
class_name PathfindModule

@export var velocity_module: VelocityModule
@export var navigation_agent: NavigationAgent2D

var target: Node2D

enum Direction {
	NONE,
	UP,
	DOWN,
	LEFT,
	RIGHT
}

var current_direction := Direction.NONE

func _ready() -> void:
	if not navigation_agent:
		push_warning("PathfindModule has no NavigationAgent2D assigned")

func set_target(new_target: Node2D):
	target = new_target

func set_target_position() -> void:
	if navigation_agent:
		navigation_agent.target_position = target.global_position

## Override this in child classes to define valid directions
func get_valid_directions() -> Array[Vector2]:
	return []

## Override this in child classes to constrain movement
func constrain_direction(direction: Vector2) -> Vector2:
	return direction

func get_direction_to_target() -> Vector2:
	if not get_parent():
		return Vector2.ZERO
	
	var direction = (target.global_position - get_parent().global_position).normalized()
	return constrain_direction(direction)

func move_toward_target() -> void:
	if not velocity_module:
		return
	
	var direction = get_direction_to_target()
	update_current_direction(direction)
	velocity_module.move(direction)

func get_random_cardinal_direction() -> Vector2:
	var directions := get_valid_directions()
	return directions.pick_random() if not directions.is_empty() else Vector2.ZERO

func snap_to_cardinal(direction: Vector2) -> Vector2:
	if direction == Vector2.ZERO:
		return Vector2.ZERO
	
	if abs(direction.x) > abs(direction.y):
		return Vector2(sign(direction.x), 0)
	else:
		return Vector2(0, sign(direction.y))

func update_current_direction(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		current_direction = Direction.NONE
	elif direction == Vector2.UP or (direction.y < 0 and abs(direction.y) > abs(direction.x)):
		current_direction = Direction.UP
	elif direction == Vector2.DOWN or (direction.y > 0 and abs(direction.y) > abs(direction.x)):
		current_direction = Direction.DOWN
	elif direction.x < 0:
		current_direction = Direction.LEFT
	elif direction.x > 0:
		current_direction = Direction.RIGHT

func get_direction_string() -> String:
	match current_direction:
		Direction.UP:
			return "up"
		Direction.DOWN:
			return "down"
		Direction.LEFT:
			return "left"
		Direction.RIGHT:
			return "right"
		_:
			return "none"

func get_current_direction() -> Direction:
	return current_direction

func move_in_direction(direction: Vector2) -> void:
	if not velocity_module:
		return
	
	var constrained = constrain_direction(direction)
	update_current_direction(constrained)
	velocity_module.move(constrained)

func get_horizontal_direction_to_target() -> float:
	if not get_parent():
		return 0.0
	
	return sign(target.global_position.x - get_parent().global_position.x)

func is_closer_than(distance: float) -> bool:
	if not target or not get_parent():
		return false
	return get_parent().global_position.distance_to(target.global_position) < distance
