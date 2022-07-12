const Constants = preload("Constants.gd")
const Enemy = preload("Enemy.gd")

var _enemies = []
var _textures = []
var _to_pick = []

func _init():
	_load_textures()
	_refresh_textures()

func _load_textures():
	for link in Constants.kadra_texture_links:
		_textures.append(load(link))

func _refresh_textures():
	_to_pick += _textures

func _pick_texture():
	var texture = _to_pick[rand_range(0, _to_pick.size())]
	
	_to_pick.erase(texture)
	if _to_pick.empty():
		_refresh_textures()
	
	return texture

func generate_enemy():
	var left_start = false
	if rand_range(0, 2) as int == 1:
		left_start = true
	_enemies.append(Enemy.new(left_start, _pick_texture()))

func remove_enemy(enemy):
	_enemies.erase(enemy)

func get_enemies():
	return _enemies
