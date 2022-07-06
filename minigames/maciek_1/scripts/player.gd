extends RigidBody2D

export var engine_power: float
export var break_power: float

export var tire_grip: float
var ground_grip: float = 1.0


export onready var fr_wheel = get_node("FR Wheel")
export onready var fl_wheel = get_node("FL Wheel")
export onready var br_wheel = get_node("BR Wheel")
export onready var bl_wheel = get_node("BL Wheel")

func _ready() -> void:
	print(fl_wheel.ground_grip)

# in radians
export var max_steering_angle: float

var i := 0

func _physics_process(delta: float) -> void:
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
	

func _on_some_ground_grip_update(car: Node2D, new_grip: float) -> void:
	if car == self:
		return;
		print(self, " changed their ground_grip to ", new_grip)
		ground_grip = new_grip

