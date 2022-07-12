extends KinematicBody2D

const Constants = preload("Constants.gd")

var _is_running = true

func game_over():
	_is_running = false

func _ready():
	pass

func _physics_process(delta):
	var direction = Vector2()
	
	if _is_running:
		if Input.is_action_pressed("up"):
			direction.y -= 1
		if Input.is_action_pressed("down"):
			direction.y += 1
		if Input.is_action_pressed("right"):
			direction.x += 1
		if Input.is_action_pressed("left"):
			direction.x -= 1
		
		direction = direction.normalized()
		
		look_at(position + direction)
		
		direction = move_and_slide(direction * Constants.movespeed)
