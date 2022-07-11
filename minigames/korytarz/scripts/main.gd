extends Node2D

const EnemyFactory = preload("enemy/EnemyFactory.gd")
const Player = preload("player/Player.gd")

var _enemy_factory = null

func _stop_game():
	for enemy in _enemy_factory.get_enemies():
		enemy.game_over()
	
	var player = get_node("Player")
	player.has_lost()

func _ready():
	_enemy_factory = EnemyFactory.new()
	
	for enemy in _enemy_factory.get_enemies():
		add_child(enemy)

func _process(delta):
	for enemy in _enemy_factory.get_enemies():
		if enemy.has_found_player():
			_stop_game()

func _on_CorridorLeft_body_entered(body):
	if body is Player:
		_stop_game()

func _on_CorridorRight_body_entered(body):
	if body is Player:
		_stop_game()
