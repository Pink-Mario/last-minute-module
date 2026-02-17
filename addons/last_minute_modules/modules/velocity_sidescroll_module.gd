extends VelocityModule
class_name SidescrollerVelocityModule

@export var max_fall_speed := 600.0

var gravity := ProjectSettings.get_setting("physics/2d/default_gravity")

var is_on_floor := false

func move(direction: Vector2) -> void:
	if knocked_back:
		return
	if direction.x != 0:
		velocity.x = direction.normalized().x * max_speed
	else:
		velocity.x = 0.0
		
func apply_gravity(delta: float) -> void:
	velocity.y = min(velocity.y + gravity * delta, max_fall_speed)

func update_knockback(delta: float) -> void:
	super.update_knockback(delta)
	if knocked_back:
		velocity.y = knockback_velocity.y

func reset() -> void:
	super.reset()
