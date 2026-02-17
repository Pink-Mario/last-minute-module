## A resource that defines damage properties for hitboxes and projectiles.
##
## DamageData encapsulates all information needed to apply damage to a target,
## including the damage amount, type, and optional knockback effects.
## Attach this to a HitboxModule or ProjectileModule to define how much damage
## they deal and any knockback behavior.
##
## @tutorial: Create a new DamageData resource in the inspector and configure
## the properties, then assign it to your hitbox's damage_data export.
extends Resource
class_name DamageData

## The amount of damage dealt to the target's HealthModule.
@export var dmg: int = 10

## The type of damage (e.g., "Fire", "Ice", "Physical").
## Can be used for damage resistance/weakness systems.
@export var dmg_type: String = "None"

## Whether this damage applies knockback force to the target.
@export var has_knockback: bool = true

## The strength of the knockback force applied to the target's VelocityModule.
@export var knockback_power: float = 100.0

## How long (in seconds) the knockback effect lasts.
@export var knockback_duration: float = 0.25
