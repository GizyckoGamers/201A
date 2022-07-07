const Constants = preload("Constants.gd")

### GENERATE SPOTS
func _generate_spot():
	if rand_range(0, 100) < Constants.balcony_chance:  # room or balcony
		var id: int = rand_range(0, Constants.rooms_amount/2)
		var spot = Constants.balcony_spots[rand_range(0, Constants.balcony_spots.size())]
		
		return Vector2(spot.x + 560*id, spot.y)
	else:
		var id: int = rand_range(0, Constants.rooms_amount)
		var spot = Constants.room_spots[rand_range(0, Constants.room_spots.size())]
		
		return Vector2(spot.x + 280*id, spot.y)

func _generate_spots():
	var spots = []

	randomize()
	for i in range(Constants.rooms_amount):
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
		
	var current = starting_position

	var min_dist
	var min_index
	var dist 
	for i in range(to_visit.size()):
		min_dist = 1e9
		
		for index in range(len(to_visit)):
			if is_visited[index]:
				continue
			
			dist = _get_distance(current, to_visit[index])
			if dist < min_dist:
				min_dist = dist 
				min_index = index
		
		current = to_visit[min_index]
		is_visited[min_index] = true
		path.append(to_visit[min_index])
	

	return path


### RETURN RESULT
func get_spots_path(starting_position):
	var spots = _generate_spots()
	var path = _find_path(starting_position, spots)
	
	return path
