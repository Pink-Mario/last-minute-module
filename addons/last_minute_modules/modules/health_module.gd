## Manages health, damage, healing, and death for game entities.
##
## HealthModule provides a complete health system with signals for health changes,
## damage taken, healing, and death. It integrates with IFrameModule for invincibility
## frames after taking damage, and tracks the direction and source of the last hit
## for knockback and visual feedback purposes.
##
## @tutorial: Add as a child node and connect signals to respond to health events.
## Reference this module in HurtboxModule to receive damage from hitboxes.
@icon("res://addons/last_minute_modules/icons/icon-health.png")
extends Node
class_name HealthModule

## Emitted when health value changes. Provides old and new values.
signal health_changed(old_health: int, new_health: int)
## Emitted when health reaches zero.
signal died
## Emitted when health is restored to max_health.
signal health_full
## Emitted when damage is taken. Provides the damage amount.
signal damage_taken(damage: int)
## Emitted when health is restored. Provides the heal amount.
signal health_restored(amount: int)
## Emitted when max_health is changed. Provides old and new max values.
signal max_health_changed(old_max: int, new_max: int)

## The maximum health value. Health cannot exceed this.
@export var max_health = 100
## Optional IFrameModule to trigger invincibility after taking damage.
@export var iframe_module: IFrameModule

## When true, the entity cannot take damage from any source.
var invincible = false

## Current health value.
var health = 0
## Direction vector pointing from this entity toward the last damage source.
var last_damage_dir: Vector2 = Vector2.ZERO
## Reference to the HitboxModule that last dealt damage to this entity.
var last_damage_source: HitboxModule

func _ready() -> void:
	health = max_health

func take_damage(amount: int, source: Node2D) -> void:
	if iframe_module and !iframe_module.is_stopped():
		return
	if invincible or amount <= 0:
		return
	last_damage_dir = get_parent().global_position.direction_to(source.global_position)
	if source is HitboxModule:
		last_damage_source = source
	else:
		last_damage_source = source.get_parent()
	var old_health = health
	health = max(0, health - amount)
	damage_taken.emit(amount)
	health_changed.emit(old_health, health)
	if health <= 0:
		died.emit()
	elif iframe_module:
		iframe_module.trigger_iframes()

func heal(amount: int) -> void:
	if amount <= 0:
		return
	var old_health = health
	health = min(max_health, health + amount)
	if health != old_health:
		health_restored.emit(amount)
		health_changed.emit(old_health, health)
		if health >= max_health:
			health_full.emit()

func set_health(value: int) -> void:
	var old_health = health
	health = clamp(value, 0, max_health)
	
	if health != old_health:
		health_changed.emit(old_health, health)
		
		if health <= 0:
			died.emit()
		elif health >= max_health:
			health_full.emit()

func restore_full_health() -> void:
	heal(max_health)

func kill() -> void:
	take_damage(health, null)

func set_max_health(value: int) -> void:
	if value <= 0:
		return
	
	var old_max = max_health
	max_health = value
	
	if health > max_health:
		health = max_health
	
	max_health_changed.emit(old_max, max_health)

func increase_max_health(amount: int) -> void:
	set_max_health(max_health + amount)

func decrease_max_health(amount: int) -> void:
	set_max_health(max_health - amount)

func is_alive() -> bool:
	return health > 0

func is_dead() -> bool:
	return health <= 0

func is_full_health() -> bool:
	return health >= max_health

func get_health() -> int:
	return health

func get_max_health() -> int:
	return max_health

func get_health_percent() -> float:
	if max_health == 0:
		return 0.0
	return float(health) / float(max_health)

func get_missing_health() -> int:
	return max_health - health

func has_health(amount: int) -> bool:
	return health >= amount

func set_invincible(value: bool) -> void:
	invincible = value

func toggle_invincible() -> void:
	invincible = !invincible

func is_invincible() -> bool:
	return invincible
