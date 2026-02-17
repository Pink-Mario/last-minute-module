extends Area2D
class_name HitboxModule

@export var damage_data: DamageData
@export var group_module: GroupModule

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	if damage_data:
		damage_data = damage_data.duplicate()

func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxModule:
		var hurtbox = area as HurtboxModule
		var hurtbox_health = hurtbox.health_module as HealthModule
		
		if not area.is_same_team(self):
			hurtbox.take_hit(self)

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
