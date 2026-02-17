extends Marker2D
class_name MuzzleModule

signal fired(projectile: ProjectileModule)

@export var projectile_scene: PackedScene
@export var group_module: GroupModule
## If true, fires along the muzzle's own facing direction (global_transform.x)
## If false, you pass a direction in manually
@export var use_own_direction: bool = true
@export var spread_degrees: float = 0.0
@export var projectiles_per_shot: int = 1

func _ready() -> void:
	if group_module == null:
		group_module = get_parent().get_node_or_null("GroupModule")

func fire(direction: Vector2 = Vector2.ZERO) -> void:
	if not projectile_scene:
		push_warning("MuzzleModule: no projectile_scene assigned")
		return
	var shoot_dir: Vector2
	if use_own_direction:
		shoot_dir = global_transform.x
	else:
		shoot_dir = direction.normalized() if direction.length() > 0 else global_transform.x
	
	for i in projectiles_per_shot:
		_spawn_projectile(shoot_dir)

func fire_at(target: Vector2) -> void:
	var dir = global_position.direction_to(target)
	fire(dir)

func fire_at_node(target: Node2D) -> void:
	fire_at(target.global_position)

func _spawn_projectile(base_direction: Vector2) -> void:
	var instance = projectile_scene.instantiate()
	get_tree().current_scene.add_child(instance)
	instance.global_position = global_position
	
	if not instance is ProjectileModule:
		push_warning("MuzzleModule: projectile_scene root is not a ProjectileModule")
		return
	
	var projectile := instance as ProjectileModule
	
	if group_module:
		projectile.group_module = group_module
		
	var final_direction = base_direction
	if spread_degrees > 0.0:
		var spread_rad = deg_to_rad(randf_range(-spread_degrees / 2.0, spread_degrees / 2.0))
		final_direction = base_direction.rotated(spread_rad)
	
	projectile.set_direction(final_direction)
	fired.emit(projectile)
