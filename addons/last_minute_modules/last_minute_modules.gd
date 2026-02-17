@tool
extends EditorPlugin

var all_modules := [
	"VelocityModule",
	"SidescrollerVelocityModule",
	"TopdownVelocityModule",
	"HealthModule",
	"IFrameModule",
	"GroupModule",
	"DamageData",
	"HitboxModule",
	"HurtboxModule",
	"ProjectileModule",
	"MuzzleModule",
	"StateHandler",
	"State"
]

func _enable_plugin() -> void:
	add_custom_type("VelocityModule", "Node", preload("res://addons/last_minute_modules/modules/velocity_module.gd"), preload("res://addons/last_minute_modules/icons/icon-debug.png"))
	add_custom_type("SidescrollerVelocityModule", "VelocityModule", preload("res://addons/last_minute_modules/modules/velocity_sidescroll_module.gd"), preload("res://addons/last_minute_modules/icons/icon-2Dvelocity.png"))
	add_custom_type("TopdownVelocityModule", "VelocityModule", preload("res://addons/last_minute_modules/modules/velocity_module_topdown.gd"), preload("res://addons/last_minute_modules/icons/icon-topdownvelocity.png"))
	add_custom_type("HealthModule", "Node", preload("res://addons/last_minute_modules/modules/health_module.gd"), preload("res://addons/last_minute_modules/icons/icon-health.png"))
	add_custom_type("IFrameModule", "Node", preload("res://addons/last_minute_modules/modules/iframe_module.gd"), preload("res://addons/last_minute_modules/icons/icon-health.png"))
	add_custom_type("GroupModule", "Node", preload("res://addons/last_minute_modules/modules/group_module.gd"), preload("res://addons/last_minute_modules/icons/icon-group.png"))
	add_custom_type("DamageData", "Resource", preload("res://addons/last_minute_modules/resources/damage_data.gd"), preload("res://addons/last_minute_modules/icons/icon-hitbox.png"))
	
	add_custom_type("HitboxModule", "Area2D", preload("res://addons/last_minute_modules/modules/hitbox_module.gd"), preload("res://addons/last_minute_modules/icons/icon-hurtbox.png"))
	add_custom_type("HurtboxModule", "Area2D", preload("res://addons/last_minute_modules/modules/hurtbox_module.gd"), preload("res://addons/last_minute_modules/icons/icon-hitbox.png"))
	
	add_custom_type("ProjectileModule", "HitboxModule", preload("res://addons/last_minute_modules/modules/projectile_module.gd"), preload("res://addons/last_minute_modules/icons/icon-bullet.png"))
	add_custom_type("MuzzleModule", "Marker2D", preload("res://addons/last_minute_modules/modules/muzzle_module.gd"), preload("res://addons/last_minute_modules/icons/icon-bullet.png"))
	
	add_custom_type("StateHandler", "Node", preload("res://addons/last_minute_modules/modules/state_handler/state_handler.gd"), preload("res://addons/last_minute_modules/icons/icon-statehandler.png"))
	add_custom_type("State", "Node", preload("res://addons/last_minute_modules/modules/state_handler/state.gd"), preload("res://addons/last_minute_modules/icons/icon-state.png"))
	
	add_autoload_singleton("HelperScript", "res://addons/last_minute_modules/helper_script.gd")
	
func _disable_plugin() -> void:
	for type_name in all_modules:
		remove_custom_type(type_name)
	remove_autoload_singleton("HelperScript")

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
