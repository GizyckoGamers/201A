extends RigidBody2D

export var engine_power: float
export var break_power: float

export var tire_grip: float
export var turn_feel_num: float
export var wheel_feel_num: float
#export var wheels_forward_friction: float

onready var fuck_off: Node2D = get_node("piss_test")

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
	pass
#	apply_central_impulse(Vector2.UP * 100)

func calculate_wheel_physics_forces(total_turn_angle: float) -> Vector2:
	var rot := rot_to_vec2(global_rotation)
	return rot
	var move_angle: float = get_linear_velocity().angle_to(rot)
	var clamped_angle := clamp(move_angle, -PI / 2, PI / 2)
	var common_mull := tire_grip * wheel_feel_num
	print("move_angle = ", move_angle)
	
	# handle rear tires
	var rr_force := rr_grip * common_mull * clamped_angle
	var rl_force := rl_grip * common_mull * clamped_angle
	# handle front tires
	var fr_force := fr_grip * common_mull * clamp(move_angle - total_turn_angle, -PI / 2, PI / 2)
	var fl_force := fl_grip * common_mull * clamp(move_angle - total_turn_angle, -PI / 2, PI / 2)
	return -rot_to_vec2(rotation) * rr_force * rl_force * fr_force * fl_force
	

func move_once_more(delta: float, state: Physics2DDirectBodyState):
	var throttle := Input.get_action_strength("up")
	var breaks := Input.get_action_strength("down")
	var turn_angle := (Input.get_action_strength("right") - Input.get_action_strength("left")) * max_steering_angle
	state.apply_torque_impulse(turn_angle * delta)
	
	var total_torque: float = 0
	var total_force := Vector2.ZERO
	
	var rr_pow := throttle * (tire_grip * rr_grip) * engine_power
	var rl_pow := throttle * (tire_grip * rl_grip) * engine_power
	
	var all_wheel_non_user_forces := calculate_wheel_physics_forces(turn_angle)
	
	print("linear_velocity = ", linear_velocity)
	print("global_rotation = ", global_rotation)
	print("vec(global_rotation) = ", rot_to_vec2(global_rotation))
	print("all_wheel_non_user_forces = ", all_wheel_non_user_forces)
	print("\n")
	
	state.add_central_force(rot_to_vec2(rotation) * (throttle - breaks) * 10)
#	state.add_central_force((throttle - breaks) * Vector2.UP * 10)


var i := 0
func move_again(delta: float, state: Physics2DDirectBodyState):
	var throttle := Input.get_action_strength("up")
	var breaks := Input.get_action_strength("down")
	var turn_angle := (Input.get_action_strength("right") - Input.get_action_strength("left")) * max_steering_angle
	
	var rr_pow := throttle * (tire_grip * rr_grip) * engine_power
	var rl_pow := throttle * (tire_grip * rl_grip) * engine_power
	
	var direction := rot_to_vec2(rotation)
	
	if i<50: i+=1;
	else:
		i = 0
#		print(angular_velocity)
#		print(linear_velocity)
#		print("\n")
#		print("turn_angle = ", turn_angle)
#		print("manual = ", Vector2(cos(rotation), sin(rotation)).normalized())
#		print("built-in = ", Vector2.UP.rotated(rotation).normalized())
#		print("\n")
#		print("direction = ", direction)
	
	state.apply_torque_impulse(turn_angle * delta)
#	state.apply_central_impulse((Vector2.UP * (throttle - breaks) * delta))
#	state.apply_central_impulse((Vect.rotated(rotation) * 1 * rr_pow).rotated(rotation), Vector2.UP * 100)
	state.add_force(rr_wheel.global_position, direction * rr_pow * delta)
	state.add_force(rl_wheel.global_position, direction * rl_pow * delta)
#	state.apply_impulse(rl_wheel.position, direction * rl_pow * delta)

# WHY ON OUR BEAUTIFUL BUT DYING EARTH WOULD SOMEONE NOT WRITE THAT THE ROTATION IS TO THE POSITIVE X-AXIS
# I'VE WASTED SO MUCH TIME DEBUGING ALL OF THIS
# ALSO WHY IS THE Y-AXIS INVERSED????? WHO HURT THE CONTRIBUTORS???
func rot_to_vec2(rot: float) -> Vector2:
	return Vector2(sin(rot), -cos(rot))

func move(delta: float):
#	var world_rot := global_position.angle_to(Vector2.RIGHT)
	var world_rot := global_rotation
	var throttle := Input.get_action_strength("up")
	var breaks := Input.get_action_strength("down")
	var turn_angle := (Input.get_action_strength("right") - Input.get_action_strength("left")) * max_steering_angle
	
	var rr_pow := throttle * (tire_grip * rr_grip) * engine_power
	var rl_pow := throttle * (tire_grip * rl_grip) * engine_power
	
#	var fr_friction := (Vector2(-wheels_forward_friction, turn_angle * turn_feel_num) * fr_grip * tire_grip).rotated(-turn_angle)
#	var fl_friction := (Vector2(-wheels_forward_friction, turn_angle * turn_feel_num) * fl_grip * tire_grip).rotated(-turn_angle)

#	var p1 := Vector2(cos(world_rot), sin(world_rot)).normalized() * rr_pow
	var p1 := Vector2.UP * rr_pow
	var pos1: Vector2 = rr_wheel.global_position
#	var p2 := Vector2(cos(world_rot), sin(world_rot)).normalized() * rl_pow
	var p2 := Vector2.UP * rl_pow
	var pos2: Vector2 = rl_wheel.global_position
	
	assert(global_rotation >= -2 * PI and global_rotation <= 2 * PI)
	
	apply_impulse(pos1, p1)
	apply_impulse(pos2, p2)
	

func _integrate_forces(state: Physics2DDirectBodyState):
	applied_force = Vector2.ZERO
	applied_torque = 0
	
	move_once_more(state.step, state)
#	move_again(state.step, state)


func _physics_process(delta: float):
	return;
	var turn: float = (Input.get_action_strength("right") - Input.get_action_strength("left")) * max_steering_angle
	
	apply_torque_impulse(turn * delta * 1000)
	
	var engine := Input.get_action_strength("up") * engine_power
	var breaks := Input.get_action_strength("down") * break_power
	
	print("engine = ", engine)
	
	var force := Vector2(cos(rotation), sin(rotation))
	force *= engine - breaks
	apply_central_impulse(force * delta)


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
