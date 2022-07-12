const Constants = preload("Constants.gd")

var _progress_per_second = null
var _spot_progress = 0  # out of 100 %

func _init():
	_progress_per_second = 100 / Constants.spotting_time

func _distance_weight(distance):
	if distance <= Constants.close_distance:
		return 1
	else:
		return distance / Constants.distance_weight
 
func spot(distance, delta):
	if distance > 0:
		_spot_progress += (_progress_per_second * delta) / _distance_weight(distance)
	else:
		_spot_progress = 0
	
	if _spot_progress > 100:
		_spot_progress = 100

func get_progress():
	return _spot_progress
