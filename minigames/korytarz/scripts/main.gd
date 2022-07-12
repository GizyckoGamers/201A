extends Node2D

const EnemyFactory = preload("enemy/EnemyFactory.gd")
const Player = preload("player/Player.gd")

var _enemy_factory = null
var _game_state = "IN PROGRESS"

func _end_game():
	for enemy in _enemy_factory.get_enemies():
		enemy.game_over()
	
	var player = get_node("Player")
	player.game_over()
	
	var restart_button = get_node("Player/CanvasLayer/RestartButton")
	restart_button.visible = true
	
	var time_text = get_node("Player/CanvasLayer/TimeText")
	time_text.stop()

func _loose_game():	
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
			break
		
	var timer = get_node("Player/CanvasLayer/TimeText")
	if timer.check_finished():
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
