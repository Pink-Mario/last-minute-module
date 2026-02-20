## An Area2D that deals damage to HurtboxModules on contact.
##
## HitboxModule is the offensive component of the combat system. When it overlaps
## with a HurtboxModule from a different group, it automatically applies damage
## based on its DamageData resource. Use this for melee attacks, hazards, or any
## damage-dealing collision area.
##
## In the editor, collision shapes are tinted red for easy identification.
##
## @tutorial: Add CollisionShape2D children to define the damage area.
## Assign a DamageData resource and optionally a GroupModule for team filtering.
@tool
@icon("res://addons/last_minute_modules/icons/icon-hurtbox.png")
extends Area2D
class_name HitboxModule

## The damage configuration applied when hitting a target.
@export var damage_data: DamageData
## Optional group for friendly fire prevention. If set, won't damage same-group targets.
@export var group_module: GroupModule
## Optional velocity for automatic flipping
@export var velocity_module: VelocityModule

## Emitted when this hitbox successfully hits a hurtbox.
signal hit(hurtbox: HurtboxModule)

const HITBOX_LAYER := 1 << 30 # Layer 31
const HURTBOX_LAYER := 1 << 31 # Layer 32

func _ready() -> void:
	if not Engine.is_editor_hint():
		area_entered.connect(_on_area_entered)
		if damage_data:
			damage_data = damage_data.duplicate()
	else:
		_update_debug_colors()
	
	collision_layer = HITBOX_LAYER
	collision_mask = HURTBOX_LAYER

func _update_debug_colors():
	for child in get_children():
		if child is CollisionShape2D:
			child.debug_color = Color(1, 0, 0, 0.4)

func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxModule:
		var hurtbox = area as HurtboxModule
		var hurtbox_health = hurtbox.health_module as HealthModule
		
		if not area.is_same_team(self):
			hurtbox.take_hit(self)
			emit_signal("hit", area)

func get_damage():
	return damage_data.dmg

func set_damage(new_damage: int) -> void:
	if damage_data:
		damage_data.dmg = new_damage

func modify_damage(amount: int) -> void:
	if damage_data:
		damage_data.dmg += amount

func set_knockback_power(power: float) -> void:
	if damage_data:
		damage_data.knockback_power = power

func velocity_flip():
	if not velocity_module: return
	var x_dir = velocity_module.velocity.x
	if x_dir > 0:
		scale.x = 1
	elif x_dir < 0:
		scale.x = -1

func _process(delta: float) -> void:
	velocity_flip()
