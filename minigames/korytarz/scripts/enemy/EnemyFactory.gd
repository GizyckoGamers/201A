const Constants = preload("Constants.gd")
const Enemy = preload("Enemy.gd")

var _enemies = []

func _init():
	for i in range(Constants.enemy_amount):
		_generate_enemy()
		
func _generate_enemy():
	var left_start = false
	if rand_range(0, 2) as int == 1:
		left_start = true
	_enemies.append(Enemy.new(left_start))

func get_enemies():
	return _enemies