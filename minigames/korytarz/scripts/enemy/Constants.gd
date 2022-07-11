const rooms_amount = 8
const enemy_amount = 1

const movespeed = 200
const rotationspeed = 2
const spot_amount = 14
const balcony_chance = 10  # %  - (out of 100) 
const view_angle = PI/6
const color = Color(0.5, 0.5, 0.5)

const start_door = [
	Vector2(-120, 680), # before entrance
	Vector2(120, 680)   # after entrance
]

const end_door = [
	Vector2(2000, 680), # before entrance
	Vector2(2400, 680)   # after entrance
]

const room_spots = [
	Vector2(40, 440),
	Vector2(40, 160),
	Vector2(180, 440),
	Vector2(180, 160),
]

const room_door = [
	Vector2(120, 560), # before entrance
	Vector2(120, 440)  # after entrance
] 

const balcony_spots = [
	Vector2(40, 40),
	Vector2(480, -40),
	Vector2(320, 80),
]

const balcony_left_door = [
	Vector2(200, 160), # before left entrance
	Vector2(200, 40),  # after left entrance
]
const balcony_right_door = [
	Vector2(320, 160), # before right entrance
	Vector2(320, 40)   # after right entrance
]

const kadra_spawn_left_spots = [
	Vector2(-120, 320),
	Vector2(-120, 420),
	Vector2(-120, 520),
	Vector2(-120, 620)
]

const kadra_spawn_right_spots = [
	Vector2(2400, 320),
	Vector2(2400, 420),
	Vector2(2400, 520),
	Vector2(2400, 620)
]
