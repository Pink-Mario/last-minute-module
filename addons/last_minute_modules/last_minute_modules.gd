@tool
extends EditorPlugin


func _enable_plugin() -> void:
	add_custom_type("VelocityModule", "Node", preload("res://addons/last_minute_modules/modules/velocity_module.gd"), preload("res://addons/last_minute_modules/icons/icon-debug.png"))
	add_custom_type("SidescrollerVelocityModule", "VelocityModule", preload("res://addons/last_minute_modules/modules/velocity_sidescroll_module.gd"), preload("res://addons/last_minute_modules/icons/icon-2Dvelocity.png"))
	add_autoload_singleton("HelperScript", "res://addons/last_minute_modules/helper_script.gd")
	

func _disable_plugin() -> void:
	remove_autoload_singleton("HelperScript")


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
