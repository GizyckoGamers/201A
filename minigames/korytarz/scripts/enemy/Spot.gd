const Constants = preload("Constants.gd")

var is_balcony = null
var room_id = null
var position = Vector2.ZERO

func _init():
	var coordinates: Vector2
	
	is_balcony = rand_range(0, 100) < Constants.balcony_chance
	
	if is_balcony:
		room_id = rand_range(0, Constants.rooms_amount/2) as int
		coordinates = Constants.balcony_spots[rand_range(0, Constants.balcony_spots.size())]
		
		position = Vector2(coordinates.x + 280 * (room_id / 2) * 2, coordinates.y)
	else:
		room_id = rand_range(0, Constants.rooms_amount) as int
		coordinates = Constants.room_spots[rand_range(0, Constants.room_spots.size())]
		
		position = Vector2(coordinates.x + 280*room_id, coordinates.y)
