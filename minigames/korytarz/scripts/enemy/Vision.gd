const Constants = preload("Constants.gd")
const Player = preload("../player/Player.gd")

var _ray = null

func generate_raycast(enemy, player):
	print(player)
	print(player.global_position)
	
	_ray.cast_to = player.global_position
	enemy.add_child(_ray)
	_ray.enabled = true

func check_player_found(enemy):
	return _ray.is_colliding() and enemy.get_collider() is Player
