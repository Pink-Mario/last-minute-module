extends Node
class_name VelocityModule

@export_category("Speed")
@export var max_speed = 150.0

var velocity = Vector2.ZERO

var knockback_velocity := Vector2.ZERO
var knockback_time_left := 0.0
var knocked_back = false

func move(direction: Vector2) -> void:
	if knocked_back:
		return
	
	if direction.length() > 0:
		direction = direction.normalized()
		velocity = direction * max_speed
	else:
		velocity = Vector2.ZERO

func get_velocity() -> Vector2:
	return velocity

func set_velocity(new_velocity: Vector2) -> void:
	velocity = new_velocity

func add_thrust(thrust_power: Vector2) -> void:
	velocity += thrust_power
	
func apply_knockback(force: Vector2, duration: float) -> void:
	if force.length() < knockback_velocity.length():
		return
	knockback_velocity = force
	knockback_time_left = duration
	knocked_back = true

func update_knockback(delta: float) -> void:
	if knockback_time_left > 0.0:
		velocity = knockback_velocity
		knockback_time_left -= delta
		if knockback_time_left <= 0.0:
			knocked_back = false
			knockback_velocity = Vector2.ZERO

func reset() -> void:
	velocity = Vector2.ZERO
