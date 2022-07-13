extends Node2D

const TimerConstants = preload("timer/Constants.gd")
const EnemyConstants = preload("enemy/Constants.gd")
const EnemyFactory = preload("enemy/EnemyFactory.gd")
const Player = preload("player/Player.gd")

var _enemy_factory = null
var _to_wave = 0  # in seconds
var _game_state = "IN PROGRESS"

func _update_spotting(value):
	var spotting_bar = get_node("Player/CanvasLayer/SpottingProgressBar/SpottingProgressBar")
	spotting_bar.value = value

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

func _add_enemy():
	if _enemy_factory.get_enemies().size() == EnemyConstants.enemy_amount:
		return
	
	var enemy = _enemy_factory.generate_enemy()
	
	if enemy:
		add_child(enemy)

func _ready():
	randomize()
	
	_enemy_factory = EnemyFactory.new()
	
	_add_enemy()

func _process(delta):
	var max_progress = 0
	for enemy in _enemy_factory.get_enemies():
		if enemy.get_spotting_progress():
			max_progress = max(max_progress, enemy.get_spotting_progress())
	
	_update_spotting(max_progress)
	if max_progress == 100:
		_loose_game()
			
	var timer = get_node("Player/CanvasLayer/TimeText")
	if timer.check_finished():
		_win_game()
	
	_to_wave += delta
	if _to_wave > EnemyConstants.time_spacing:
		_add_enemy()
		_to_wave -= EnemyConstants.time_spacing

func _on_Staircase_body_entered(body):
	if body is Player:
		_loose_game()

func _on_Railings_body_entered(body):
	if body is Player:
		var player = get_node("Player")
		player.slow_down()

func _on_Railings_body_exited(body):
	if body is Player:
		var player = get_node("Player")
		player.remove_slow()

func _on_BackButton_pressed():
	get_tree().change_scene("res://MainMenu.tscn")

func _on_RestartButton_pressed():
	get_tree().change_scene("res://minigames/korytarz/korytarz - main.tscn")
