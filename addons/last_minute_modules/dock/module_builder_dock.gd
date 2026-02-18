@tool
extends VBoxContainer

var editor_plugin: EditorPlugin

var templates := {
	"Sidescroller Character": {
		"base": "CharacterBody2D",
		"modules": ["SidescrollerVelocityModule", "HealthModule", "HurtboxModule", "GroupModule", "StateHandler"],
		"children": [
			{"type": "CollisionShape2D", "name": "CollideShape"},
			{"type": "Sprite2D", "name": "PlayerSprite"},
		]
	},
	"Topdown Character": {
		"base": "CharacterBody2D",
		"modules": ["TopdownVelocityModule", "HealthModule", "HurtboxModule", "GroupModule", "StateHandler"],
		"children": [
			{"type": "CollisionShape2D", "name": "CollideShape"},
			{"type": "Sprite2D", "name": "PlayerSprite"},
		]
	},
	"Sidescroller Enemy": {
		"base": "CharacterBody2D",
		"modules": ["SidescrollerVelocityModule", "PathfindModuleSideScroller", "HealthModule", "HurtboxModule", "HitboxModule", "GroupModule", "StateHandler"],
		"children": [
			{"type": "CollisionShape2D", "name": "CollideShape"},
			{"type": "Sprite2D", "name": "EnemySprite"},
		]
	},
	"Topdown Enemy": {
		"base": "CharacterBody2D",
		"modules": ["TopdownVelocityModule", "PathfindModuleTopDown", "HealthModule", "HurtboxModule", "HitboxModule", "GroupModule", "StateHandler"],
		"children": [
			{"type": "CollisionShape2D", "name": "CollideShape"},
			{"type": "Sprite2D", "name": "EnemySprite"},
		]
	},
	"Projectile": {
		"base": "ProjectileModule",
		"modules": ["GroupModule"],
		"children": [
			{"type": "Sprite2D", "name": "ProjectileSprite"},
			{"type": "CollisionShape2D", "name": "CollideShape"},
		]
	},
}

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

func _ready() -> void:
	var template_label := Label.new()
	template_label.text = "Character Templates"
	template_label.add_theme_font_size_override("font_size", 14)
	add_child(template_label)
	
	var template_container := VBoxContainer.new()
	add_child(template_container)
	
	for template_name in templates.keys():
		var btn := Button.new()
		btn.text = template_name
		btn.pressed.connect(_on_template_pressed.bind(template_name))
		template_container.add_child(btn)
	
	add_child(HSeparator.new())
	
	var module_label := Label.new()
	module_label.text = "Add Module to Selected"
	module_label.add_theme_font_size_override("font_size", 14)
	add_child(module_label)
	
	var module_container := VBoxContainer.new()
	add_child(module_container)
	
	for module_name in quick_modules:
		var btn := Button.new()
		btn.text = module_name
		btn.pressed.connect(_on_module_pressed.bind(module_name))
		module_container.add_child(btn)
	
	add_child(HSeparator.new())
	
	var helper_label := Label.new()
	helper_label.text = "Quick Helpers"
	helper_label.add_theme_font_size_override("font_size", 14)
	add_child(helper_label)
	
	var helper_container := VBoxContainer.new()
	add_child(helper_container)
	
	var sprite_btn := Button.new()
	sprite_btn.text = "+ Sprite2D"
	sprite_btn.pressed.connect(_add_base_node.bind("Sprite2D"))
	helper_container.add_child(sprite_btn)
	
	var collision_btn := Button.new()
	collision_btn.text = "+ CollisionShape2D"
	collision_btn.pressed.connect(_add_base_node.bind("CollisionShape2D"))
	helper_container.add_child(collision_btn)
	
	var marker_btn := Button.new()
	marker_btn.text = "+ Marker2D"
	marker_btn.pressed.connect(_add_base_node.bind("Marker2D"))
	helper_container.add_child(marker_btn)

func _on_template_pressed(template_name: String) -> void:
	var template = templates[template_name]
	var editor_interface := editor_plugin.get_editor_interface()
	var edited_scene := editor_interface.get_edited_scene_root()
	
	if not edited_scene:
		push_error("No scene is currently open")
		return
	
	var base_node: Node = ClassDB.instantiate(template.base)
	base_node.name = template_name.replace(" ", "")

	for module_name in template.modules:
		var module: Node = ClassDB.instantiate(module_name)
		base_node.add_child(module)
		module.owner = edited_scene

	for child_data in template.children:
		var child: Node = ClassDB.instantiate(child_data.type)
		child.name = child_data.name

		if child_data.has("parent"):
			var parent = base_node.get_node(child_data.parent)
			if parent:
				parent.add_child(child)
				child.owner = edited_scene
		else:
			base_node.add_child(child)
			child.owner = edited_scene
	
	edited_scene.add_child(base_node)
	base_node.owner = edited_scene
	
	editor_interface.get_selection().clear()
	editor_interface.get_selection().add_node(base_node)

func _on_module_pressed(module_name: String) -> void:
	var editor_interface := editor_plugin.get_editor_interface()
	var selection := editor_interface.get_selection()
	var selected_nodes := selection.get_selected_nodes()
	
	if selected_nodes.is_empty():
		push_error("No node selected")
		return
	
	var target_node = selected_nodes[0]
	var edited_scene := editor_interface.get_edited_scene_root()

	var module: Node = ClassDB.instantiate(module_name)
	target_node.add_child(module)
	module.owner = edited_scene
	
	# If it's a hitbox/hurtbox/projectile, add a CollisionShape2D child
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
	
	var new_node: Node = ClassDB.instantiate(node_type)
	target_node.add_child(new_node)
	new_node.owner = edited_scene
