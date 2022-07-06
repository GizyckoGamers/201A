extends KinematicBody2D

var rooms_amount = 8  # map

# player property
var spot_amount = 14
var balcony_chance = 10  # %  - (out of 100) 


var room_spots = [
	Vector2(40, 440),
	Vector2(160, 160),
	Vector2(400, 200)
]
	
var balcony_spots = [
	Vector2(40, 40),
	Vector2(320, 80)
]

var spots = []

 # diff between room -> 280
 # diff between balcony -> 280*2 = 560

func _generate_spot():
	randomize()

	if rand_range(0, 100) < balcony_chance:  # room or balcony
		var id = rand_range(0, rooms_amount/2)
		var spot = balcony_spots[rand_range(0, balcony_spots.size)]
		return Vector2(spot.x + 560*id, spot.y)
	else:
		var id = rand_range(0, rooms_amount)
		var spot = room_spots[rand_range(0, room_spots.size)]
		return Vector2(spot.x + 280*id, spot.y)


func _ready():
	# generate spots to visit
	for i in range(rooms_amount):
		spots.append(_generate_spot())
		
	spots.sort()

	for spot in spots:
		print(spot)

func _process(delta):
	pass
