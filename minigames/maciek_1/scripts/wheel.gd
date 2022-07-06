extends Area2D


func _on_some_ground_grip_update(wheel, new_grip) -> void:
	if wheel == self:
		print(self, " changed ground_grip to ", new_grip)
		get_tree().root
