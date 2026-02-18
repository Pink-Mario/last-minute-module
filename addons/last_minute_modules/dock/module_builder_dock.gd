@tool
extends ScrollContainer

var editor_plugin: EditorPlugin
@onready var module_builder_dock_v: VBoxContainer = $ModuleBuilderDockV

var quick_modules := [
	"SidescrollerVelocityModule",
	"TopdownVelocityModule",
	"PathfindModuleSideScroller",
	"PathfindModuleTopDown",
	"HealthModule",
	"IFrameModule",
	"HurtboxModule",
	"HitboxModule",
	"StateHandler",
	"State",
	"MuzzleModule",
]

var module_paths := {
	"SidescrollerVelocityModule": "res://addons/last_minute_modules/modules/velocity_sidescroll_module.gd",
	"TopdownVelocityModule": "res://addons/last_minute_modules/modules/velocity_module_topdown.gd",
	"PathfindModuleSideScroller": "res://addons/last_minute_modules/modules/pathfind_module_sidescroller.gd",
	"PathfindModuleTopDown": "res://addons/last_minute_modules/modules/pathfind_module_topdown.gd",
	"HealthModule": "res://addons/last_minute_modules/modules/health_module.gd",
	"IFrameModule": "res://addons/last_minute_modules/modules/iframe_module.gd",
	"HurtboxModule": "res://addons/last_minute_modules/modules/hurtbox_module.gd",
	"HitboxModule": "res://addons/last_minute_modules/modules/hitbox_module.gd",
	"StateHandler": "res://addons/last_minute_modules/modules/state_handler/state_handler.gd",
	"State": "res://addons/last_minute_modules/modules/state_handler/state.gd",
	"MuzzleModule": "res://addons/last_minute_modules/modules/muzzle_module.gd",
	"GroupModule": "res://addons/last_minute_modules/modules/group_module.gd",
	"ProjectileModule": "res://addons/last_minute_modules/modules/projectile_module.gd",
}

func _ready() -> void:
	var template_label := Label.new()
	template_label.text = "Tree Templates"
	template_label.add_theme_font_size_override("font_size", 14)
	module_builder_dock_v.add_child(template_label)
	
	var template_container := VBoxContainer.new()
	module_builder_dock_v.add_child(template_container)
	
	var module_label := Label.new()
	module_label.text = "Quick Modules"
	module_label.add_theme_font_size_override("font_size", 14)
	module_builder_dock_v.add_child(module_label)
	
	var module_container := VBoxContainer.new()
	module_builder_dock_v.add_child(module_container)
	
	for module_name in quick_modules:
		var btn := Button.new()
		btn.text = module_name
		btn.pressed.connect(_on_module_pressed.bind(module_name))
		module_container.add_child(btn)
	
	module_builder_dock_v.add_child(HSeparator.new())
	
	var helper_label := Label.new()
	helper_label.text = "Convenice"
	helper_label.add_theme_font_size_override("font_size", 14)
	module_builder_dock_v.add_child(helper_label)
	
	var helper_container := VBoxContainer.new()
	module_builder_dock_v.add_child(helper_container)
	
	var sprite_btn := Button.new()
	sprite_btn.text = "+ Sprite"
	sprite_btn.pressed.connect(_add_base_node.bind("Sprite2D"))
	helper_container.add_child(sprite_btn)
	
	var collision_btn := Button.new()
	collision_btn.text = "+ Collision Shape"
	collision_btn.pressed.connect(_add_base_node.bind("CollisionShape2D"))
	helper_container.add_child(collision_btn)
	
	var marker_btn := Button.new()
	marker_btn.text = "+ Animation"
	marker_btn.pressed.connect(_add_base_node.bind("AnimationPlayer"))
	helper_container.add_child(marker_btn)

func _create_node(node_type: String) -> Node:
	var node
	if module_paths.has(node_type):
		var script = load(module_paths[node_type])
		node = script.new()
		return node
	else:
		node = ClassDB.instantiate(node_type)
	return node
		
func _on_module_pressed(module_name: String) -> void:
	var editor_interface := editor_plugin.get_editor_interface()
	var selection := editor_interface.get_selection()
	var selected_nodes := selection.get_selected_nodes()
	
	if selected_nodes.is_empty():
		push_error("No node selected")
		return
	
	var target_node = selected_nodes[0]
	var edited_scene := editor_interface.get_edited_scene_root()

	var module: Node = _create_node(module_name)
	target_node.add_child(module)
	module.owner = edited_scene
	
	if module_name in ["HitboxModule", "HurtboxModule", "ProjectileModule"]:
		var collision := CollisionShape2D.new()
		collision.name = "CollisionShape2D"
		module.add_child(collision)
		collision.owner = edited_scene

func _add_base_node(node_type: String) -> void:
	var editor_interface := editor_plugin.get_editor_interface()
	var selection := editor_interface.get_selection()
	var selected_nodes := selection.get_selected_nodes()
	
	if selected_nodes.is_empty():
		push_error("No node selected")
		return
	
	var target_node = selected_nodes[0]
	var edited_scene := editor_interface.get_edited_scene_root()
	
	var new_node: Node = _create_node(node_type)
	target_node.add_child(new_node)
	new_node.owner = edited_scene
