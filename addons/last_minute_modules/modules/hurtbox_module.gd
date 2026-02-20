## An Area2D that receives damage from HitboxModules.
##
## HurtboxModule is the defensive component of the combat system. When overlapped
## by a HitboxModule from a different group, it receives damage and applies knockback
## to the associated VelocityModule. Connect this to a HealthModule to track damage.
##
## In the editor, collision shapes are tinted blue for easy identification.
##
## @tutorial: Add CollisionShape2D children to define the vulnerable area.
## Assign references to HealthModule (required for damage) and optionally
## VelocityModule (for knockback) and GroupModule (for team filtering).
@tool
@icon("res://addons/last_minute_modules/icons/icon-hitbox.png")
extends Area2D
class_name HurtboxModule

## Optional velocity module to apply knockback forces when hit.
@export var velocity_module: VelocityModule
## The health module that receives damage from incoming hits.
@export var health_module: HealthModule
## Optional group for friendly fire prevention. If set, won't receive damage from same-group hitboxes.
@export var group_module: GroupModule

const HITBOX_LAYER := 1 << 30 # Layer 31
const HURTBOX_LAYER := 1 << 31 # Layer 32

func _ready():
	if Engine.is_editor_hint():
		_update_debug_colors()
	
	collision_layer = HURTBOX_LAYER
	collision_mask = HITBOX_LAYER

func _update_debug_colors():
	for child in get_children():
		if child is CollisionShape2D:
			child.debug_color = Color(0.2, 0.4, 1, 0.4)

func take_hit(hitbox: HitboxModule):
	if health_module and hitbox.damage_data:
		health_module.take_damage(hitbox.damage_data.dmg, hitbox)
		if velocity_module and hitbox.damage_data.has_knockback:
			var knockback_dir = hitbox.global_position.direction_to(global_position)
			var knockback_force = knockback_dir * hitbox.damage_data.knockback_power
			velocity_module.apply_knockback(knockback_force, hitbox.damage_data.knockback_duration)

func is_same_team(hitbox: HitboxModule) -> bool:
	if group_module == null or hitbox.group_module == null:
		return true
	return group_module.group != hitbox.group_module.group
