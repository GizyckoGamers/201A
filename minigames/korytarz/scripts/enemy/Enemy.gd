extends KinematicBody2D

const Constants = preload("Constants.gd")
const SpotsGenerator = preload("SpotsGenerator.gd")
const Movement = preload("Movement.gd")
const Vision = preload("Vision.gd")
const enemy_texture = preload("../../sprites/enemy.png")

var _movement = null
var _vision = null
var _left_start = null
var _is_player_found = false

func _init(left_start):
	_left_start = left_start
	
	if _left_start:
		global_position = Constants.kadra_spawn_left_spots[rand_range(0, Constants.kadra_spawn_left_spots.size())]
	else:
		global_position = Constants.kadra_spawn_right_spots[rand_range(0, Constants.kadra_spawn_right_spots.size())]
	
	var sprite = Sprite.new()
	sprite.texture = enemy_texture
	add_child(sprite)

func _ready():
	var spots = SpotsGenerator.new().get_spots_path()
	
	if not _left_start:
		spots.invert()
	
	var level_navigation = get_node("../LevelNavigation")
	var player = get_node("../Player")
	
	_movement = Movement.new(level_navigation, global_position, spots)
	_vision = Vision.new(self, player)

func _physics_process(delta):
	if _movement and not _is_player_found:
		_movement.current_position = global_position
		
		var direction = _movement.navigate()
		
		var angle = transform.x.angle_to(direction)
		rotate(sign(angle) * min(delta * Constants.rotationspeed, abs(angle)))
		
		update()
		if _vision.check_see_player():
			_is_player_found = true
		
		if is_zero_approx(angle):
			move_and_slide(direction * Constants.movespeed)

func has_found_player():
	return _is_player_found

func game_over():
	_is_player_found = true

func _draw():
	if _vision:
		_vision.update_vision_lines()
