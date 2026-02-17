## Pathfinding module for side-scrolling movement
##
## Primarily horizontal movement with optional vertical movement for flying enemies
## Preserves vertical velocity component for gravity.

extends PathfindModule
class_name PathfindModuleSideScroller

## Whether vertical movement is allowed (ladders, flying enemies, etc.)
@export var allow_vertical_movement: bool = false

func get_valid_directions() -> Array[Vector2]:
	if allow_vertical_movement:
		return [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
	else:
		return [Vector2.RIGHT, Vector2.LEFT]

func constrain_direction(direction: Vector2) -> Vector2:
	if direction == Vector2.ZERO:
		return Vector2.ZERO
	
	if allow_vertical_movement:
		return snap_to_cardinal(direction)
	else:
		# Preserve Y component for gravity, only snap X to horizontal
		return snap_to_horizontal(direction)

## Snaps to cardinal but preserves the Y component (useful for gravity)
func snap_to_horizontal(direction: Vector2) -> Vector2:
	return Vector2(sign(direction.x) if abs(direction.x) > 0.1 else 0, direction.y)
