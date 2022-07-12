extends KinematicBody2D

const Constants = preload("Constants.gd")

var _is_running = true

func game_over():
	_is_running = false

func _ready():
	pass

func _physics_process(delta):
	var motion = Vector2()
	var tolook = position
	
	if _is_running:
		if Input.is_action_pressed("up"):
			motion.y -= 1
			tolook.y -= 1
		if Input.is_action_pressed("down"):
			motion.y += 1
			tolook.y += 1
		if Input.is_action_pressed("right"):
			motion.x += 1
			tolook.x += 1
		if Input.is_action_pressed("left"):
			motion.x -= 1
			tolook.x -= 1
		
		look_at(tolook)
		
		motion.normalized()
		motion = move_and_slide(motion * Constants.movespeed)
