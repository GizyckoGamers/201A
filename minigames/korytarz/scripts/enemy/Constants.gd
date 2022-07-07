extends Node

const rooms_amount = 8

const movespeed = 200
const rotationspeed = 2.0
const spot_amount = 14
const balcony_chance = 10  # %  - (out of 100) 

const room_spots = [
	Vector2(40, 440),
	Vector2(40, 160),
	Vector2(180, 440),
	Vector2(180, 160)
]
	
const balcony_spots = [
	Vector2(40, 40),
	Vector2(480, -40),
	Vector2(320, 80)
]
