extends KinematicBody2D

const Constants = preload("Constants.gd")
const Joystick = preload("res://common/joystick/Joystick.gd")

var _is_running = true
var _joystick = null

func game_over():
	_is_running = false

func _init():
	var room_id = rand_range(0, Constants.rooms_amount) as int 
	
	global_position = Vector2(Constants.starting_position.x + 280*room_id, 
	Constants.starting_position.y)

	_joystick = Joystick.new()

func _physics_process(delta):
	var direction = Vector2.ZERO
	
	if _is_running:
		# Joysitck has higher priority than keyboard
		if _joystick.get_move() == Vector2.ZERO:
			if Input.is_action_pressed("up"):
				direction.y -= 1
			if Input.is_action_pressed("down"):
				direction.y += 1
			if Input.is_action_pressed("right"):
				direction.x += 1
			if Input.is_action_pressed("left"):
				direction.x -= 1
			direction.normalized()
		direction += _joystick.get_move()
		
		look_at(position + direction)
		
		direction = move_and_slide(direction * Constants.movespeed)

func _on_Joystick_move_vector(move_vector):
	_joystick.move(move_vector)
