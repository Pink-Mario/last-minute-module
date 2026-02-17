extends Timer
class_name IFrameModule

@export var visual: Node2D
@export var iframe_duration = 0.4

var _is_visible = false
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
