const Constants = preload("Constants.gd")

var _hour = null
var _minute = null
var _seconds = null
var _time_per_second = null   # seconds to seconds
var _is_elapsed = false

func _set_time_per_second():
	var hour_diff = Constants.end_hour - Constants.start_hour
	if Constants.end_hour < Constants.start_hour:
		hour_diff += 24
	
	var minute_diff = Constants.end_minute - Constants.start_minute
	if Constants.end_minute < Constants.start_minute:
		minute_diff += 60
	
	_time_per_second = (hour_diff * 60 + minute_diff) / Constants.game_duration

func _init():
	_hour = Constants.start_hour
	_minute = Constants.start_minute
	_seconds = 0
	
	_set_time_per_second()

func update(delta):
	if not _is_elapsed:
		_seconds += delta * _time_per_second
		
		_minute += (_seconds / 60) as int
		while _seconds >= 60:
			_seconds -= 60
		
		_hour += (_minute / 60) as int
		_minute %= 60
		
		if _hour >= 24:
			_hour -= 24
			
		if _hour == Constants.end_hour and _minute == Constants.end_minute:
			_is_elapsed = true

func display():
	var to_display = ""
	
	if _hour < 10:
		to_display += "0"
	to_display += str(_hour)
	
	to_display += ":"
	if _minute < 10:
		to_display += "0"
	to_display += str(_minute)
	
	return to_display

func check_elapsed():
	return _is_elapsed
