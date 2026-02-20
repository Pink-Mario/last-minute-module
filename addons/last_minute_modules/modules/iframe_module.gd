## Provides invincibility frames (i-frames) with visual flickering feedback.
##
## IFrameModule creates a brief period of invulnerability after taking damage,
## preventing the entity from being hit multiple times in quick succession.
## During i-frames, an optional visual node will flicker to indicate invincibility.
##
## This module extends Timer and should be referenced by a HealthModule to
## automatically trigger i-frames when damage is taken.
##
## @tutorial: Add as a child node and reference it in your HealthModule's iframe_module export.
## Optionally assign a Sprite2D or other Node2D to the visual export for flickering.
@icon("res://addons/last_minute_modules/icons/icon-health.png")
extends Timer
class_name IFrameModule

## The Node2D whose alpha will be modulated during i-frames to create a flicker effect.
@export var visual: Node2D
## How long the invincibility period lasts (in seconds).
@export var iframe_duration = 0.4

var _is_visible = false
## Time interval between visibility toggles during the flicker effect.
var flicker_interval = 0.1
var _flicker_timer: Timer

func _ready() -> void:
	wait_time = iframe_duration
	one_shot = true
	_flicker_timer = Timer.new()
	_flicker_timer.timeout.connect(_on_flicker_timeout)
	add_child(_flicker_timer)
	
func trigger_iframes() -> void:
	start()
	if visual:
		_is_visible = true
		_flicker_timer.start(flicker_interval)

func _on_flicker_timeout() -> void:
	_is_visible = not _is_visible
	var alpha = 0.3 if not _is_visible else 1.0
	
	if visual:
		visual.modulate.a = alpha

func _on_timer_timeout() -> void:
	stop()
	if visual:
		visual.modulate.a = 1.0
		
	_is_visible = true
	
func is_active() -> bool:
	return not is_stopped()
