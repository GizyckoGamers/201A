extends KinematicBody2D

const Constants = preload("Constants.gd")

var _is_running = true

func game_over():
	_is_running = false

func _ready():
	pass

const joy_deadzone = 0.01
var joystick := Vector2(0,0)

func _physics_process(delta):
	var direction = Vector2()
	
	if _is_running:
		# Joysitck has higher priority than keyboard
		if joystick == Vector2(0,0):
			if Input.is_action_pressed("up"):
				direction.y -= 1
			if Input.is_action_pressed("down"):
				direction.y += 1
			if Input.is_action_pressed("right"):
				direction.x += 1
			if Input.is_action_pressed("left"):
				direction.x -= 1
			direction.normalized()
		elif joystick.length() > joy_deadzone:
			direction += joystick
		
		look_at(position + direction)
		
		direction = move_and_slide(direction * Constants.movespeed)

func _on_Joystick_move_vector(move_vector):
	joystick = move_vector
