## A spawn point for projectiles with configurable direction and spread.
##
## MuzzleModule handles projectile instantiation, positioning, and direction.
## It supports automatic firing along its facing direction or manual direction control,
## with optional spread for shotgun-style attacks. Multiple projectiles can be
## fired per shot with randomized spread within the defined arc.
##
## In the editor, displays a visual indicator showing the firing direction
## and spread angle (yellow cone/line).
##
## @tutorial: Position this Marker2D where projectiles should spawn.
## Assign a projectile scene (must have ProjectileModule as root) and call fire().
@icon("res://addons/last_minute_modules/icons/icon-bullet.png")
@tool
extends Marker2D
class_name MuzzleModule

## Emitted when a projectile is fired. Provides the spawned projectile instance.
signal fired(projectile: ProjectileModule)

## The scene to instantiate when firing. Root node must be a ProjectileModule.
@export var projectile_scene: PackedScene
## Optional group module to assign to spawned projectiles for team filtering.
@export var group_module: GroupModule
## If true, fires along the muzzle's own facing direction (global_transform.x).
## If false, you pass a direction in manually via fire().
@export var use_own_direction: bool = true
## Random spread angle in degrees. Projectiles will fire within ±(spread_degrees/2) of the base direction.
@export_range(0.0, 180.0) var spread_degrees: float = 0.0:
	set(value):
		spread_degrees = value
		queue_redraw()
## Number of projectiles spawned per fire() call.
@export var projectiles_per_shot: int = 1
## Length of the direction indicator line in the editor.
@export var editor_visual_length: float = 50.0:
	set(value):
		editor_visual_length = value
		queue_redraw()

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	if group_module == null:
		group_module = get_parent().get_node_or_null("GroupModule")

func _draw() -> void:
	if not Engine.is_editor_hint():
		return
	
	var line_color = Color.YELLOW
	var line_width = 2.0
	
	# Draw the main firing direction
	var end_point = Vector2(editor_visual_length, 0)
	draw_line(Vector2.ZERO, end_point, line_color, line_width)
	
	# Draw arrowhead
	var arrow_size = 8.0
	var arrow_angle = deg_to_rad(150)
	draw_line(end_point, end_point + Vector2(arrow_size, 0).rotated(arrow_angle), line_color, line_width)
	draw_line(end_point, end_point + Vector2(arrow_size, 0).rotated(-arrow_angle), line_color, line_width)
	
	if spread_degrees > 0.0:
		var half_spread = deg_to_rad(spread_degrees / 2.0)
		var spread_color = Color(1.0, 1.0, 0.0, 0.3)
		
		var upper_end = Vector2(editor_visual_length, 0).rotated(-half_spread)
		var lower_end = Vector2(editor_visual_length, 0).rotated(half_spread)
		draw_line(Vector2.ZERO, upper_end, spread_color, line_width)
		draw_line(Vector2.ZERO, lower_end, spread_color, line_width)
		
		var arc_points = PackedVector2Array()
		var arc_segments = 16
		for i in range(arc_segments + 1):
			var angle = -half_spread + (half_spread * 2.0 * i / arc_segments)
			arc_points.append(Vector2(editor_visual_length, 0).rotated(angle))
		for i in range(arc_segments):
			draw_line(arc_points[i], arc_points[i + 1], spread_color, line_width)

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
