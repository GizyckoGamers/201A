extends Node2D

const EnemyFactory = preload("enemy/EnemyFactory.gd")
const Player = preload("player/Player.gd")

var _enemy_factory = null
var _game_state = "IN PROGRESS"

func _loose_game():
	for enemy in _enemy_factory.get_enemies():
		enemy.game_over()
	
	var player = get_node("Player")
	player.has_lost()
	
	_game_state = "LOST"

func _win_game():
	_game_state = "WIN"

func _ready():
	_enemy_factory = EnemyFactory.new()
	
	for enemy in _enemy_factory.get_enemies():
		add_child(enemy)

func _process(delta):
	for enemy in _enemy_factory.get_enemies():
		if enemy.has_found_player():
			_loose_game()
			
	var all_done = true
	for enemy in _enemy_factory.get_enemies():
		if not enemy.check_done():
			all_done = false
	if all_done:
		_win_game()

func _on_CorridorLeft_body_entered(body):
	if body is Player:
		_loose_game()

func _on_CorridorRight_body_entered(body):
	if body is Player:
		_loose_game()

func _on_BackButton_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
