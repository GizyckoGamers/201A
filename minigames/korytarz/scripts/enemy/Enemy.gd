extends KinematicBody2D

const Constants = preload("Constants.gd")
const SpotsGenerator = preload("SpotsGenerator.gd")
const Movement = preload("Movement.gd")

var movement = null

func _ready():
	var initial_position = global_position

	var spots = SpotsGenerator.new().get_spots_path(initial_position)
	
	var level_navigation = get_node("../LevelNavigation")
	
	movement = Movement.new(level_navigation, initial_position, spots)


func _physics_process(delta):
	var motion = Vector2()
	var direction = Vector2()

	if movement:
		movement.current_position = global_position
		var list = movement.navigate()
		motion = list[0]; direction = list[1]
		var angle = transform.x.angle_to(direction)
		rotate(sign(angle) * min(delta * Constants.rotationspeed, abs(angle)))
		
	motion.normalized()
	motion = move_and_slide(motion * Constants.movespeed)
	
	# rotate
	# bool: needs to rotate
