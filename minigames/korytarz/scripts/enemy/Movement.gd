const Constants = preload("Constants.gd")

var _level_navigation = null
var current_position = null
var _spots = null
var _path: Array = []

func _init(level_navigation, initial_position, spots):
	_level_navigation = level_navigation
	current_position = initial_position
	_spots = spots
	
	_path = _generate_path()

func _generate_path():
	if _level_navigation != null:
		return _level_navigation.get_simple_path(current_position, _spots[0].position, true)

func _is_close(position1: Vector2, position2: Vector2):
	return abs(position1.x - position2.x) < 4 && abs(position1.y - position2.y) < 4

func _next_spot():
	if !_spots.empty():

		if _is_close(current_position, _spots[0].position):
			print("Reached")
			print(_spots[0].position)
			_spots.pop_front()
			
			if (!_spots.empty()): # else -> done
				_path = _generate_path()

func navigate():
	if _path.size() > 0:
		var motion = current_position.direction_to(_path[0])
		var direction = (_path[0] - current_position)
		
		if _is_close(current_position, _path[0]):
			_path.pop_front()

		return [motion, direction]
	
	_next_spot()
	return [Vector2.ZERO, Vector2.ZERO]
