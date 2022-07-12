extends Node2D

const TimeDisplay = preload("TimeDisplay.gd")

var _time_display = null
var _is_playing = true

func _ready():
	_time_display = TimeDisplay.new()

func _process(delta):
	if _is_playing:
		_time_display.update(delta)
		
		var time_text = find_node("TimeText")
		time_text.text = _time_display.display()
		
		if _time_display.check_elapsed():
			stop()

func stop():
	_is_playing = false
	
func check_finished():
	return _time_display.check_elapsed()
