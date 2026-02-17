## Assigns the parent node to a faction/team group for combat interactions.
##
## GroupModule determines which "side" an entity belongs to, enabling the
## HitboxModule and HurtboxModule to differentiate between friendly and hostile
## targets. Entities with the same group will not damage each other.
##
## The module automatically adds the parent node to the corresponding Godot group
## ("player", "enemies", or "misc") on ready.
##
## @tutorial: Add this module as a child of your character/enemy node and set
## the group property in the inspector. Reference it in HitboxModule and HurtboxModule.
extends Node
class_name GroupModule

## The faction this entity belongs to. Determines friendly fire rules.
@export var group: ACTOR_GROUPS = ACTOR_GROUPS.PLAYER

## Available actor groups/factions for combat differentiation.
enum ACTOR_GROUPS {
	PLAYER,  ## Player-controlled entities and allies
	ENEMY,   ## Hostile entities that can damage the player
	MISC     ## Neutral entities (e.g., destructible objects, NPCs)
}

func _ready() -> void:
	var parent = get_parent()
	match group:
		ACTOR_GROUPS.PLAYER:
			parent.add_to_group("player")
		ACTOR_GROUPS.ENEMY:
			parent.add_to_group("enemies")
		ACTOR_GROUPS.MISC:
			parent.add_to_group("misc")
