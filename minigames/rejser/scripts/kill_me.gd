extends KinematicBody2D

export var wheel_base: float = 70
export var steering_angle: float = 15
export var engine_power: float = 800
export var friction: float = -0.9
export var drag: float = -0.001
export var braking: float = -450
export var max_speed_reverse: float = 250
export var slip_speed: float = 400
export var traction_fast: float = 0.1
export var traction_slow: float = 0.7
export var max_gear: int = 5
export var max_rpm: int = 5500
var gear: int = 0
var rpm: int = 0

var acceleration := Vector2.ZERO
var velocity := Vector2.ZERO
var steer_direction
var fully_stopping: bool = false

func assert_or_print(lhs: float, rhs: float):
	if is_equal_approx(lhs, rhs):
		print("%s != %s" % [lhs, rhs])
		assert(is_equal_approx(lhs, rhs))

func _get_power(gear: int, rpm: int) -> float:
	var x: float = rpm as float / 6000 as float
	return (2*x)/(1.218 * log(gear + 1) * pow(3*x, x))
	
func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
	velocity = move_and_slide(velocity)

func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	acceleration += drag_force + friction_force

func get_input():
	var turn = 0
	if Input.is_action_pressed("right"):
		turn += 1
	if Input.is_action_pressed("left"):
		turn -= 1
	steer_direction = turn * deg2rad(steering_angle)
	acceleration += transform.x * engine_power * Input.get_action_strength("up")
	acceleration += transform.x * braking * Input.get_action_strength("down")
	# TODO: rewrite so that it works
	#if Input.is_action_just_pressed("right_key"):
	#	gear = clamp(gear + 1, -1, max_gear)
	#	
	#if Input.is_action_just_pressed("left_key"):
	#	gear = clamp(gear - 1, -1, max_gear)
	
	fully_stopping = Input.is_action_pressed("ui")

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
	if d < 0:
		if !fully_stopping:
			velocity = -new_heading * min(velocity.length(), max_speed_reverse)
		else:
			velocity = Vector2.ZERO
	rotation = new_heading.angle()
	
	
func _ready():
	assert_or_print(_get_power(1, 3709), 1)


func _on_Area2D_body_exited(body: Node) -> void:
	print("a cunt left the track: ", body)
