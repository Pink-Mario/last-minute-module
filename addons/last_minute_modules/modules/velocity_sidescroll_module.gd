## Movement controller for side-scrolling platformer games.
##
## SidescrollerVelocityModule restricts horizontal movement to left/right and
## adds gravity support for jumping and falling. It respects the project's
## default gravity setting and caps fall speed to prevent terminal velocity issues.
##
## @tutorial: Call move() with horizontal input, apply_gravity() each physics frame,
## and apply get_velocity() to your CharacterBody2D. Update is_on_floor after move_and_slide().
@icon("res://addons/last_minute_modules/icons/icon-2Dvelocity.png")
extends VelocityModule
class_name SidescrollerVelocityModule

## Maximum downward velocity to prevent excessive fall speeds.
@export var max_fall_speed := 600.0

## Gravity acceleration from project settings (pixels/second²).
var gravity := ProjectSettings.get_setting("physics/2d/default_gravity")

## Track floor contact state. Update this after CharacterBody2D.move_and_slide().
var is_on_floor := false
var was_on_floor := false

signal just_landed()

func _ready():
	#floor_check_timer()
	pass

func floor_check_timer():
	while true:
		was_on_floor = is_on_floor
		await HelperScript.delay(0.1)

func move(direction: Vector2) -> void:
	if knocked_back:
		return
	if direction.x != 0:
		velocity.x = direction.normalized().x * max_speed
	else:
		velocity.x = 0.0

func apply_gravity(delta: float) -> void:
	if not was_on_floor and is_on_floor:
		just_landed.emit()
		velocity.y = 0.0
	
	if is_on_floor:
		velocity.y = 0.0
	else:
		velocity.y = min(velocity.y + gravity * delta, max_fall_speed)

	was_on_floor = is_on_floor

func update_knockback(delta: float) -> void:
	super.update_knockback(delta)
	if knocked_back:
		velocity.y = knockback_velocity.y

func reset() -> void:
	super.reset()
