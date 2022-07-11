extends Node2D

const EnemyFactory = preload("enemy/EnemyFactory.gd")

var _enemy_factory = null

func _ready():
	_enemy_factory = EnemyFactory.new()
	
	for enemy in _enemy_factory.get_enemies():
		add_child(enemy)

func _process(delta):
	pass
