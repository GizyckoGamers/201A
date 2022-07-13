extends KinematicBody2D

const Constants = preload("Constants.gd")
const SpotsGenerator = preload("SpotsGenerator.gd")
const Movement = preload("Movement.gd")
const Vision = preload("Vision.gd")
const Spotting = preload("Spotting.gd")

var _spotsGenerator = null
var _movement = null
var _vision = null
var _spotting = null
var _left_start = null
var _is_running = true
var _texture = null

func _init(left_start, texture):
	_left_start = left_start
	_texture = texture
	if _left_start:
		global_position = Constants.kadra_spawn_left_spots[rand_range(0, Constants.kadra_spawn_left_spots.size())]
	else:
		global_position = Constants.kadra_spawn_right_spots[rand_range(0, Constants.kadra_spawn_right_spots.size())]
	
	var sprite = Sprite.new()
	sprite.texture = _texture
	add_child(sprite)

func _ready():
	var level_navigation = get_node("../LevelNavigation")
	var player = get_node("../Player")
	
	_spotsGenerator = SpotsGenerator.new()
	_movement = Movement.new(level_navigation, global_position)
	_vision = Vision.new(self, player)
	_spotting = Spotting.new()
	
	var spots = _spotsGenerator.get_spots_path(_left_start)
	_movement.load_spots(spots)

func _physics_process(delta):
	if _movement and _is_running:
		_movement.update_position(global_position)
		
		var direction = _movement.navigate()
		
		if _movement.is_finished():
			_recycle()
		
		var angle = transform.x.angle_to(direction)
		rotate(sign(angle) * min(delta * Constants.rotationspeed, abs(angle)))
		
		update()
		var distance = _vision.get_spotting_distance()
		_spotting.spot(distance, delta)
		
		if is_zero_approx(angle):
			move_and_slide(direction * Constants.movespeed)

func get_spotting_progress():
	return _spotting.get_progress()

func game_over():
	_is_running = false

func _recycle():
	_left_start = not _left_start
	var spots = _spotsGenerator.get_spots_path(_left_start)
	_movement.load_spots(spots)

func _draw():
	if _vision:
		_vision.update_vision_lines()
