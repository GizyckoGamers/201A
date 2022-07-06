extends RigidBody2D

export var engine_power: float
export var break_power: float

export var tire_grip: float
export var turn_feel_num: float
export var wheels_forward_friction: float

var fr_grip: float = 1
var fl_grip: float = 1
var rr_grip: float = 1
var rl_grip: float = 1


export onready var fr_wheel = get_node("FR Wheel")
export onready var fl_wheel = get_node("FL Wheel")
export onready var rr_wheel = get_node("BR Wheel")
export onready var rl_wheel = get_node("BL Wheel")

onready var back_wheel_displacement: Vector2 = rr_wheel.transform.origin - rl_wheel.transform.origin
onready var front_wheel_displacement: Vector2 = fr_wheel.transform.origin - fl_wheel.transform.origin
onready var wheel_axis_displacement: Vector2 = (fr_wheel.transform.origin + fl_wheel.transform.origin) - (rr_wheel.transform.origin + rl_wheel.transform.origin)

# in radians
export var max_steering_angle: float


func _ready():
	apply_impulse(Vector2.ZERO, Vector2.UP * 20)
	print("back_wheel_displacement = ", back_wheel_displacement)
	print("front_wheel_displacement = ", front_wheel_displacement)
	print("wheel_axis_displacement = ", wheel_axis_displacement)
	
	return


func calculate_tire_friction() -> Vector2:
	return Vector2.ZERO

var i := 0
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
	var p2 := -Vector2.UP * rl_pow
	var pos2: Vector2 = rl_wheel.global_position
	
	
	if i < 50: i += 1;
	else:
		i=0
		print("pos1 = ", pos1)
		print("p1 = ", p1)
		print("pos2 = ", pos2)
		print("p2 = ", p2)
		print("global pos = ", global_position)
		print("world_rot = ", world_rot)
		print("###########\n")
	
	apply_impulse(pos1, p1)
	apply_impulse(pos2, p2)
	
	

func _physics_process(delta: float):
	move(delta)
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
	
	var force := Vector2(cos(rotation), sin(rotation))
	force *= engine - breaks
	apply_central_impulse(force * delta)
	

func _on_some_ground_grip_update(wheel: Node2D, new_grip: float):
	if wheel == fr_wheel:
		print("fr")
		fr_grip = new_grip
	elif wheel == fl_wheel:
		print("fl")
		fl_grip = new_grip
	elif wheel == rr_wheel:
		print("br")
		rr_grip = new_grip
	elif wheel == rl_wheel:
		print("bl")
		rl_grip = new_grip
