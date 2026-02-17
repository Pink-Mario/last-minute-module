extends VelocityModule
class_name TopdownVelocityModule

func move(direction: Vector2) -> void:
	if knocked_back:
		return
	if direction.length() > 0:
		direction = direction.normalized()
		velocity = direction * max_speed
	else:
		velocity = Vector2.ZERO
