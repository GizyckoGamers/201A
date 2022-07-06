extends RigidBody2D

export var engine_power: float
export var break_power: float

export var tire_grip: float
export var turn_feel_num: float
export var wheels_forward_friction: float

onready var fuck_off: Node2D= get_node("piss_test")

var fr_grip: float = 1
var fl_grip: float = 1
var rr_grip: float = 1
var rl_grip: float = 1

onready var fr_wheel = get_node("FR Wheel")
onready var fl_wheel = get_node("FL Wheel")
onready var rr_wheel = get_node("BR Wheel")
onready var rl_wheel = get_node("BL Wheel")

onready var back_wheel_displacement: Vector2 = rr_wheel.transform.origin - rl_wheel.transform.origin
onready var front_wheel_displacement: Vector2 = fr_wheel.transform.origin - fl_wheel.transform.origin
onready var wheel_axis_displacement: Vector2 = (fr_wheel.transform.origin + fl_wheel.transform.origin) - (rr_wheel.transform.origin + rl_wheel.transform.origin)

# in radians
export var max_steering_angle: float


func _ready():
#	apply_impulse(Vector2.ZERO, Vector2.UP * 20)
#	print("back_wheel_displacement = ", back_wheel_displacement)
#	print("front_wheel_displacement = ", front_wheel_displacement)
#	print("wheel_axis_displacement = ", wheel_axis_displacement)
	return



#func smartly_clamp_rotation(rot: float) -> float:
#	if rot >= -2 * PI and rot <= 2 * PI:
#		return rot
#
#
#	return 0.0

var i := 0
func move_again(delta: float):
	var throttle := Input.get_action_strength("up")
	var breaks := Input.get_action_strength("down")
	var turn_angle := (Input.get_action_strength("right") - Input.get_action_strength("left")) * max_steering_angle
	
	var rr_pow := throttle * (tire_grip * rr_grip) * engine_power
	var rl_pow := throttle * (tire_grip * rl_grip) * engine_power
	
	var direction := Vector2(cos(transform.get_rotation()), sin(transform.get_rotation())).normalized()
	fuck_off.rotation = rotation
	if i<50: i+=1;
	else:
		i = 0
		print(turn_angle)
#		print("direction = ", direction)
	
	apply_torque_impulse(turn_angle * delta)
	var up := Vector2.UP * (throttle - breaks) * engine_power
	apply_central_impulse(up * rotation_to_vec2(rotation))
	
#	apply_impulse(rr_wheel.position, direction * rr_pow)
#	apply_impulse(rl_wheel.position, direction * rl_pow)

func rotation_to_vec2(rot: float) -> Vector2:
	return Vector2(cos(rot), sin(rot))

func move(delta: float):
#	var world_rot := global_position.angle_to(Vector2.RIGHT)
	var world_rot := global_rotation
	var throttle := Input.get_action_strength("up")
	var breaks := Input.get_action_strength("down")
	var turn_angle := (Input.get_action_strength("right") - Input.get_action_strength("left")) * max_steering_angle
	
	var rr_pow := throttle * (tire_grip * rr_grip) * engine_power
	var rl_pow := throttle * (tire_grip * rl_grip) * engine_power
	
	var fr_friction := (Vector2(-wheels_forward_friction, turn_angle * turn_feel_num) * fr_grip * tire_grip).rotated(-turn_angle)
	var fl_friction := (Vector2(-wheels_forward_friction, turn_angle * turn_feel_num) * fl_grip * tire_grip).rotated(-turn_angle)

#	var p1 := Vector2(cos(world_rot), sin(world_rot)).normalized() * rr_pow
	var p1 := Vector2.UP * rr_pow
	var pos1: Vector2 = rr_wheel.global_position
#	var p2 := Vector2(cos(world_rot), sin(world_rot)).normalized() * rl_pow
	var p2 := Vector2.UP * rl_pow
	var pos2: Vector2 = rl_wheel.global_position
	
	assert(global_rotation >= -2 * PI and global_rotation <= 2 * PI)
	
	apply_impulse(pos1, p1)
	apply_impulse(pos2, p2)
	
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	move_again(state.step)

func _physics_process(delta: float):
#	move_again(delta)
#	move(delta)
	return;
	var turn: float = (Input.get_action_strength("right") - Input.get_action_strength("left")) * max_steering_angle
	
	apply_torque_impulse(turn * delta * 1000)
	
#	if i < 15: i += 1;
#	else:
#		break
#		i = 0
#		print(angular_velocity)
#		print(position)
#		print(linear_velocity)
#		print("################\n")
	
	var engine := Input.get_action_strength("up") * engine_power
	var breaks := Input.get_action_strength("down") * break_power
	
	print("engine = ", engine)
	
	var force := Vector2(cos(rotation), sin(rotation))
	force *= engine - breaks
	apply_central_impulse(force * delta)
	

#func _on_some_ground_grip_update(wheel: Node2D, new_grip: float):
#	if wheel == fr_wheel:
#		print("fr")
#		fr_grip = new_grip
#	elif wheel == fl_wheel:
#		print("fl")
#		fl_grip = new_grip
#	elif wheel == rr_wheel:
#		print("br")
#		rr_grip = new_grip
#	elif wheel == rl_wheel:
#		print("bl")
#		rl_grip = new_grip


func _on_some_ground_value_update(body, new_grip) -> void:
	if body == fr_wheel:
		print("fr")
		fr_grip = new_grip
	elif body == fl_wheel:
		print("fl")
		fl_grip = new_grip
	elif body == rr_wheel:
		print("br")
		rr_grip = new_grip
	elif body == rl_wheel:
		print("bl")
		rl_grip = new_grip
