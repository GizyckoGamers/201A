extends Node2D

const EnemyFactory = preload("enemy/EnemyFactory.gd")
const Player = preload("player/Player.gd")

var _enemy_factory = null
var _game_state = "IN PROGRESS"

func _end_game():
	var player = get_node("Player")
	player.game_over()
	
	var restart_button = get_node("Player/CanvasLayer/RestartButton")
	restart_button.visible = true

func _loose_game():
	for enemy in _enemy_factory.get_enemies():
		enemy.game_over()
	
	_end_game()
	_game_state = "LOST"

func _win_game():
	var brawo_text = get_node("Player/CanvasLayer/BrawoText")
	brawo_text.visible = true
	
	_end_game()
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

func _on_RestartButton_pressed():
	get_tree().change_scene("res://minigames/korytarz/korytarz - main.tscn")
