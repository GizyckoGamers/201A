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

onready var fr_wheel := get_node("FR Wheel")
onready var fl_wheel := get_node("FL Wheel")
onready var rr_wheel := get_node("BR Wheel")
onready var rl_wheel := get_node("BL Wheel")

onready var back_wheel_displacement: Vector2 = rr_wheel.transform.origin - rl_wheel.transform.origin
onready var front_wheel_displacement: Vector2 = fr_wheel.transform.origin - fl_wheel.transform.origin
onready var wheel_axis_displacement: Vector2 = (fr_wheel.transform.origin + fl_wheel.transform.origin) - (rr_wheel.transform.origin + rl_wheel.transform.origin)
