extends Area2D

export var fun_num: int = 10

var ground_grip: float

func _ready() -> void:
	ground_grip = 1


func _on_some_ground_grip_update(car, new_grip) -> void:
	if car == self:
		print(self, " changed ground_grip to ", new_grip)
		ground_grip = new_grip
