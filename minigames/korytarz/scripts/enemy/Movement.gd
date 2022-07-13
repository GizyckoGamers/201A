const Constants = preload("Constants.gd")

var _level_navigation = null
var _current_position = null
var _spots = null
var _path: Array = []

func _init(level_navigation, initial_position):
	_level_navigation = level_navigation
	_current_position = initial_position

func _generate_path():
	if _level_navigation != null:
		return _level_navigation.get_simple_path(_current_position, _spots[0].position, true)

func _is_close(position1: Vector2, position2: Vector2):
	return abs(position1.x - position2.x) < 4 and abs(position1.y - position2.y) < 4

func _next_spot():
	if not _spots.empty():
		if _is_close(_current_position, _spots[0].position):
			_spots.pop_front()
			
			if not _spots.empty():
				_path = _generate_path()

func load_spots(spots):
	_spots = spots
	_path = _generate_path()

func update_position(new_position):
	_current_position = new_position

func navigate():
	if _path.size() > 0:
		var direction = _current_position.direction_to(_path[0])
		
		if _is_close(_current_position, _path[0]):
			_path.pop_front()

		return direction
	
	_next_spot()
	return Vector2.ZERO
	
func is_finished():
	return _spots.size() == 0 and _path.size() == 0
