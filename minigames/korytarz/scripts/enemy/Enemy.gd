extends KinematicBody2D

const Constants = preload("Constants.gd")
const SpotsGenerator = preload("SpotsGenerator.gd")
const Movement = preload("Movement.gd")
const Vision = preload("Vision.gd")

var movement = null
var vision = null

func _ready():
	var initial_position = global_position

	var spots = SpotsGenerator.new().get_spots_path(initial_position)
	
	# TODO: pick which side to start from
	
	var level_navigation = get_node("../LevelNavigation")
	var player = get_node("../Player")
	
	movement = Movement.new(level_navigation, initial_position, spots)
	vision = Vision.new(self, player)

func _physics_process(delta):
	var direction = Vector2()
	
	if movement:
		movement.current_position = global_position
		
		direction = movement.navigate()
		
		var angle = transform.x.angle_to(direction)
		rotate(sign(angle) * min(delta * Constants.rotationspeed, abs(angle)))
		
		if vision.check_see_player(direction):
			print("Player is in view of an enemy " + self.to_string())

		if stepify(angle, 1e-5) != 0:
			return

	move_and_slide(direction * Constants.movespeed)
