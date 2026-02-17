## Pathfinding module for top-down movement
##
## Allows movement in all four cardinal directions with equal priority.
## Best for overhead view games like classic RPGs, twin-stick shooters, etc.

extends PathfindModule
class_name PathfindModuleTopDown

func get_valid_directions() -> Array[Vector2]:
	return [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

func constrain_direction(direction: Vector2) -> Vector2:
	if direction == Vector2.ZERO:
		return Vector2.ZERO
	
	return snap_to_cardinal(direction)
