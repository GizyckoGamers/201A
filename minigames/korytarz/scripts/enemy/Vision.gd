const Constants = preload("Constants.gd")
const Player = preload("../player/Player.gd")

var _enemy = null
var _player = null
var _space_state = null

func _init(enemy, player):
	_enemy = enemy
	_player = player
	_space_state = _enemy.get_world_2d().direct_space_state

func update_vision_lines():
	var direction1 = Vector2(5000, 0).rotated(_enemy.rotation + Constants.view_angle / 2)
	var direction2 = Vector2(5000, 0).rotated(_enemy.rotation - Constants.view_angle / 2)
	
	var result1 = _space_state.intersect_ray(_enemy.global_position, _enemy.global_position + direction1)
	var result2 = _space_state.intersect_ray(_enemy.global_position, _enemy.global_position + direction2)
	
	_enemy.draw_line(Vector2(), (result1.position - _enemy.global_position).rotated(-_enemy.rotation), Constants.color, 2.5)
	_enemy.draw_line(Vector2(), (result2.position - _enemy.global_position).rotated(-_enemy.rotation), Constants.color, 2.5)
	_enemy.draw_circle((result1.position - _enemy.global_position).rotated(-_enemy.rotation), 10, Constants.color)
	_enemy.draw_circle((result2.position - _enemy.global_position).rotated(-_enemy.rotation), 10, Constants.color)

func check_see_player():
	var result = _space_state.intersect_ray(_enemy.global_position, _player.global_position)

	if result and result.collider is Player:
		var v1 = _enemy.global_position.direction_to(_player.global_position)
		var v2 = Vector2(1, 0).rotated(_enemy.rotation)
		
		return cos(Constants.view_angle/2) <= v1.dot(v2)
