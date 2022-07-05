extends KinematicBody2D

var movespeed = 400

func _ready():
	pass 

func _physics_process(delta):
	var motion = Vector2()
	var tolook = position
	print(tolook)
	
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
	
	# looks where it goes
	look_at(tolook)
	
	motion.normalized()
	motion = move_and_slide(motion * movespeed)
	

func _process(delta):
	pass
