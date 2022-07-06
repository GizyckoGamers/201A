extends Area2D

signal ground_value_update(car, new_grip)

export var grip: float

func _on_body_entered(body: Node2D) -> void:
	print(body, " collided with ", self)
	emit_signal("ground_value_update", body, grip)
