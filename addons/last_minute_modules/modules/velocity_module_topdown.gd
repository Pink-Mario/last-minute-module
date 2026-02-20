## Movement controller optimized for top-down games (RPGs, twin-stick shooters, etc.).
##
## TopdownVelocityModule allows full 8-directional movement where the entity can
## move freely in any direction on the 2D plane. Input direction is normalized
## to ensure consistent diagonal movement speed.
##
## @tutorial: Call move() with your input direction (e.g., Input.get_vector())
## each frame, then apply get_velocity() to your CharacterBody2D.

@icon("res://addons/last_minute_modules/icons/icon-topdownvelocity.png")
extends VelocityModule
class_name TopdownVelocityModule

## Moves the entity in the given direction at max_speed. Normalizes input automatically.
func move(direction: Vector2) -> void:
	if knocked_back:
		return
	if direction.length() > 0:
		direction = direction.normalized()
		velocity = direction * max_speed
	else:
		velocity = Vector2.ZERO
