const Constants = preload("Constants.gd")
const Player = preload("../player/Player.gd")

var _enemy = null
var _player = null
var _space_state = null

func _init(enemy, player):
	_enemy = enemy
	_player = player
	_space_state = _enemy.get_world_2d().direct_space_state

func check_see_player(motion):
	var result = _space_state.intersect_ray(_enemy.global_position, _player.global_position)

	if result and result.collider is Player:
		var v1 = _enemy.global_position.direction_to(_player.global_position).normalized()
		var v2 = _enemy.global_position.direction_to(motion).normalized()
		
		return cos(Constants.view_angle/2) <= v1.dot(v2)
