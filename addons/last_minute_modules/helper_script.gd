## VARIOUS HELPER FUNCTIONS
extends Node

func delay(wait_time: float):
	await get_tree().create_timer(wait_time).timeout

func spawn_object(scene: PackedScene, position: Vector2, parent: Node = null) -> Node:
	var instance = scene.instantiate()
	if parent == null:
		parent = get_tree().current_scene
	parent.add_child(instance)
	if instance is Node2D:
		instance.global_position = position
	elif instance is Control:
		instance.position = position
	return instance

func spawn_object_deferred(scene: PackedScene, position: Vector2, parent: Node = null) -> void:
	call_deferred("spawn_object", scene, position, parent)

func get_random_offset_in_radius(radius: float) -> Vector2:
	var angle := randf() * TAU
	var distance := sqrt(randf()) * radius
	return Vector2(cos(angle), sin(angle)) * distance

func spawn_radial(
	scene: PackedScene,
	center: Vector2,
	count: int,
	radius: float,
	parent: Node = null,
	random_rotation := true,
	scale_range := Vector2.ONE
) -> void:
	for i in count:
		var offset := get_random_offset_in_radius(radius)
		var instance := spawn_object(scene, center + offset, parent)

		if instance is Node2D:
			if random_rotation:
				instance.rotation = randf() * TAU
			if scale_range != Vector2.ONE:
				instance.scale *= randf_range(scale_range.x, scale_range.y)
