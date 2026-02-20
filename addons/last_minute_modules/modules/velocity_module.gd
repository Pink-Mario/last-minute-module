## Base movement controller that manages velocity and knockback for game entities.
##
## VelocityModule provides a foundation for character movement with built-in
## knockback support. It stores velocity state but does not apply it automatically;
## you must call CharacterBody2D.move_and_slide() with get_velocity() in your
## character's _physics_process.
##
## For game-specific movement, extend this class (see TopdownVelocityModule and
## SidescrollerVelocityModule) or use it directly for custom movement logic.
##
## @tutorial: Add as a child node and call move() with input direction each frame.
## Apply the velocity to your CharacterBody2D using velocity = velocity_module.get_velocity().
@icon("res://addons/last_minute_modules/icons/icon-debug.png")
extends Node
class_name VelocityModule

@export_category("Speed")
## Maximum movement speed in pixels per second.
@export var max_speed = 150.0

## Current velocity vector. Modified by move(), knockback, and other methods.
var velocity = Vector2.ZERO

## Active knockback force being applied.
var knockback_velocity := Vector2.ZERO
## Remaining duration of the current knockback effect.
var knockback_time_left := 0.0
## True while knockback is actively overriding normal movement.
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

func insta_thrust_x(thrust_power):
	velocity.x = thrust_power
	
func thrust_x(thrust_power):
	velocity.x += thrust_power

func insta_thrust_y(thrust_power):
	velocity.y = thrust_power
	
func thrust_y(thrust_power):
	velocity.y += thrust_power

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
