extends Node

@export var group: ACTOR_GROUPS = ACTOR_GROUPS.PLAYER

enum ACTOR_GROUPS {
	PLAYER,
	ENEMY,
	MISC
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
