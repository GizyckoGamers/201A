const Constants = preload("Constants.gd")
const Spot = preload("Spot.gd")

### GENERATE SPOTS
func _generate_spot():
	return Spot.new()

func _generate_spots():
	var spots = []

	for i in range(Constants.spot_amount):
		spots.append(_generate_spot())
	
	return spots

### GET PATH
func _get_distance(position1: Vector2, position2: Vector2):
	return position1.distance_squared_to(position2)

func _find_path(starting_position, to_visit):
	var path = []
	var is_visited = []
	for i in range(to_visit.size()):
		is_visited.append(false)
		
	var current = Spot.new()
	current.position = starting_position
	
	var min_dist
	var min_index
	var dist 
	for i in range(to_visit.size()):
		min_dist = 1e9
		
		for index in range(len(to_visit)):
			if is_visited[index]:
				continue
			
			dist = _get_distance(current.position, to_visit[index].position)
			if dist < min_dist:
				min_dist = dist 
				min_index = index
		
		current = to_visit[min_index]
		is_visited[min_index] = true
		path.append(to_visit[min_index])
	
	return path

func _create_custom_spot(coordinates, room_id, is_balcony, is_door, is_leave):
	var spot = Spot.new()

	if is_balcony:
		spot.position = Vector2(coordinates.x + 280*(room_id/2)*2, coordinates.y)
	else:
		spot.position = Vector2(coordinates.x + 280*room_id, coordinates.y)
		
	spot.room_id = room_id
	spot.is_balcony = is_balcony
	spot.is_door = is_door
	spot.is_leave = is_leave
	
	return spot

func _create_door_spot(is_balcony, room_id, is_left, is_leave):
	var spots = []
	
	if is_balcony:
		if is_left:
			spots.append(_create_custom_spot(Constants.balcony_left_door[0], room_id, is_balcony, true, is_leave))
			spots.append(_create_custom_spot(Constants.balcony_left_door[1], room_id, is_balcony, true, is_leave))
		else:
			spots.append(_create_custom_spot(Constants.balcony_right_door[0], room_id, is_balcony, true, is_leave))
			spots.append(_create_custom_spot(Constants.balcony_right_door[1], room_id, is_balcony, true, is_leave))
	else:
		spots.append(_create_custom_spot(Constants.room_door[0], room_id, is_balcony, true, is_leave))
		spots.append(_create_custom_spot(Constants.room_door[1], room_id, is_balcony, true, is_leave))
	
	if is_leave:
		spots.invert()
		
	return spots

func _check_left(spot):
	if spot.room_id % 2 == 0:
		return true
	else:
		return false

func _get_all_door_spots(prev_spot, spot):
	var to_add = []
	
	if prev_spot.room_id == -1:
		to_add += _create_door_spot(false, spot.room_id, false, false)
		if spot.is_balcony:
			to_add += _create_door_spot(true, spot.room_id, _check_left(spot), false)
	
	# TODO: AI path optimization by going through balcony
	
	elif prev_spot.room_id != spot.room_id:
		
		# leave
		if prev_spot.is_balcony:
			to_add += _create_door_spot(true, prev_spot.room_id, _check_left(prev_spot), true)
		to_add += _create_door_spot(false, prev_spot.room_id, false, true)
		
		# enter
		to_add += _create_door_spot(false, spot.room_id, false, false)
		if spot.is_balcony:
			to_add += _create_door_spot(true, spot.room_id, _check_left(spot), false)
	
	elif prev_spot.is_balcony != spot.is_balcony:
		if spot.is_balcony:
			to_add += _create_door_spot(true, spot.room_id, _check_left(spot), false)
		else:
			to_add += _create_door_spot(true, spot.room_id, _check_left(spot), true)
	
	return to_add

func _add_start_and_end_doors(spots):
	return [
		_create_custom_spot(Constants.start_door[0], 0, false, true, false), 
		_create_custom_spot(Constants.start_door[1], 0, false, true, false)
	] + spots + [
		_create_custom_spot(Constants.end_door[0], 0, false, true, true),
		_create_custom_spot(Constants.end_door[1], 0, false, true, true)
	]

func _add_intermediate_spots(starting_position, spots):
	var all_spots = []
	
	var prev_spot = Spot.new()
	prev_spot.room_id = -1
	prev_spot.position = starting_position
	
	for spot in spots:
		all_spots += _get_all_door_spots(prev_spot, spot)
		
		all_spots.append(spot)
		prev_spot = spot
		
	if spots[-1].is_balcony:
		all_spots += _create_door_spot(true, spots[-1].room_id, _check_left(spots[-1]), true)
	all_spots += _create_door_spot(false, spots[-1].room_id, false, true)
	
	return all_spots

### RETURN RESULT
func get_spots_path(_left_start):
	var spots = _generate_spots()
	
	var sorted_spots = _find_path(Constants.kadra_spawn_left_spots[-1], spots)
	
	var path = _add_intermediate_spots(Constants.kadra_spawn_left_spots[-1], sorted_spots)
	
	var full_path = _add_start_and_end_doors(path)
	
	if not _left_start:
		full_path.invert()
	return full_path
