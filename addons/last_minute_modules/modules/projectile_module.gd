# ProjectileModule.gd
extends HitboxModule
class_name ProjectileModule

@export var screen_notify: VisibleOnScreenNotifier2D
@export var range: float = 0.0
@export var speed: float = 100.0
@export var speed_ramp: Curve = null
@export var hit_count: int = 1
@export var sprite: Sprite2D
@export var SPRITE_ANGLE_OFFSET: float = 90.0

var direction: Vector2 = Vector2.RIGHT
var _distance_traveled: float = 0.0
var _time_alive: float = 0.0

func _ready() -> void:
	super()
	if screen_notify:
		screen_notify.screen_exited.connect(destroy)
	area_entered.connect(_on_hit)
	proj_ready()

func _physics_process(delta: float) -> void:
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
