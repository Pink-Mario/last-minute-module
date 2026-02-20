## A moving hitbox that travels in a direction and destroys itself based on conditions.
##
## ProjectileModule extends HitboxModule to create bullets, arrows, fireballs, etc.
## It moves in a set direction at configurable speed (with optional ramping),
## and can be destroyed when: exceeding its range, hitting a target, or leaving the screen.
## may also control its parent instead of itself
##
## In the editor, displays a green line showing the maximum travel range.
##
## @tutorial: Create a scene with ProjectileModule as root, add a CollisionShape2D
## and Sprite2D. Assign this scene to a MuzzleModule's projectile_scene.
@tool
@icon("res://addons/last_minute_modules/icons/icon-bullet.png")
extends HitboxModule
class_name ProjectileModule

## Optional notifier to destroy the projectile when it leaves the screen.
@export var screen_notify: VisibleOnScreenNotifier2D
## Maximum travel distance before auto-destruction. Set to 0 for infinite range.
@export var range: float = 0.0:
	set(value):
		range = value
		queue_redraw()
## Movement speed in pixels per second.
@export var speed: float = 100.0
## Optional curve to modify speed over time. X-axis is time, Y-axis multiplies base speed.
@export var speed_ramp: Curve = null
## Number of targets this projectile can hit before being destroyed. Set to -1 for infinite piercing.
@export var hit_count: int = 1
## Optional sprite to rotate based on movement direction.
@export var sprite: Sprite2D
## Rotation offset (in degrees) applied to the sprite. Use to align sprite artwork with direction.
@export var SPRITE_ANGLE_OFFSET: float = 90.0

## Current movement direction (normalized).
var direction: Vector2 = Vector2.RIGHT
var _distance_traveled: float = 0.0
var _time_alive: float = 0.0

func _ready() -> void:
	super()
	if Engine.is_editor_hint():
		return
	if screen_notify:
		screen_notify.screen_exited.connect(destroy)
	area_entered.connect(_on_hit)
	proj_ready()

func _draw() -> void:
	if not Engine.is_editor_hint():
		return
	if range <= 0.0:
		return
	
	# Draw range line
	var range_color = Color(0.2, 0.8, 0.2, 0.7)
	var line_width = 2.0
	var end_point = Vector2(range, 0)
	
	# Main range line
	draw_line(Vector2.ZERO, end_point, range_color, line_width)
	
	# End cap (perpendicular line)
	var cap_size = 10.0
	draw_line(end_point + Vector2(0, -cap_size), end_point + Vector2(0, cap_size), range_color, line_width)
	
	# Distance markers every 50 pixels
	var marker_color = Color(0.2, 0.8, 0.2, 0.4)
	var marker_interval = 50.0
	var current_distance = marker_interval
	while current_distance < range:
		var marker_pos = Vector2(current_distance, 0)
		draw_line(marker_pos + Vector2(0, -5), marker_pos + Vector2(0, 5), marker_color, 1.0)
		current_distance += marker_interval

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	_time_alive += delta
	
	var current_speed = speed
	if speed_ramp:
		current_speed = speed * speed_ramp.sample(_time_alive)
	
	var movement = direction * current_speed * delta
	position += movement
	_distance_traveled += movement.length()
	
	if sprite:
		sprite.rotation_degrees = direction.angle() * 180.0 / PI + SPRITE_ANGLE_OFFSET
	else:
		rotation_degrees = direction.angle() * 180.0 / PI + SPRITE_ANGLE_OFFSET
	
	if range > 0.0 and _distance_traveled >= range:
		destroy()

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction.normalized()

func proj_ready() -> void:
	pass

func _on_hit(area: Area2D) -> void:
	if not area is HurtboxModule:
		return
	if hit_count == -1:
		return
	hit_count -= 1
	if hit_count <= 0:
		destroy()

func destroy() -> void:
	call_deferred("queue_free")
