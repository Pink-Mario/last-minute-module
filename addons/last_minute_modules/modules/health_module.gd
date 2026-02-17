extends Node
class_name HealthModule

signal health_changed(old_health: int, new_health: int)
signal died
signal health_full
signal damage_taken(damage: int)
signal health_restored(amount: int)
signal max_health_changed(old_max: int, new_max: int)

@export var max_health = 100
var invincible = false
var no_damage = false

var health = 0
var last_damage_dir: Vector2 = Vector2.ZERO
#var last_damage_source: Hitbox

func _ready() -> void:
	health = max_health

func take_damage(amount: int, source: Node2D) -> void:
	if invincible or amount <= 0 or no_damage:
		return
	last_damage_dir = get_parent().global_position.direction_to(source.global_position)
	var old_health = health
	health = max(0, health - amount)
	damage_taken.emit(amount)
	health_changed.emit(old_health, health)
	if health <= 0:
		died.emit()

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
