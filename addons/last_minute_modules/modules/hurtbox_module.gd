extends Area2D
class_name HurtboxModule

@export var velocity_module: VelocityModule
@export var health_module: HealthModule
@export var group_module: GroupModule

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
