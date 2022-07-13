const Constants = preload("Constants.gd")

var is_balcony = null
var room_id = null
var position = Vector2.ZERO
var is_door = false
var is_leave = false

func _init():
	var coordinates: Vector2
	
	is_balcony = rand_range(0, 100) < Constants.balcony_chance
	room_id = rand_range(0, Constants.rooms_amount) as int
	
	if is_balcony:
		if room_id % 2 == 0:
			coordinates = Constants.balcony_left_spots[rand_range(0, Constants.balcony_left_spots.size())]
		else:
			coordinates = Constants.balcony_right_spots[rand_range(0, Constants.balcony_right_spots.size())]
		position = Vector2(coordinates.x + 280 * (room_id / 2) * 2, coordinates.y)
	else:
		coordinates = Constants.room_spots[rand_range(0, Constants.room_spots.size())]
		
		position = Vector2(coordinates.x + 280*room_id, coordinates.y)
