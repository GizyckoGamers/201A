extends Node2D

const EnemyFactory = preload("enemy/EnemyFactory.gd")

var _enemy_factory = null
var _is_running = true

func _ready():
	_enemy_factory = EnemyFactory.new()
	
	for enemy in _enemy_factory.get_enemies():
		add_child(enemy)

func _process(delta):
	if _is_running:
		for enemy in _enemy_factory.get_enemies():
			if enemy.has_found_player():
				_is_running = false
	else:
		for enemy in _enemy_factory.get_enemies():
			enemy.game_over()
		
		var player = get_node("Player")
		player.has_lost()
