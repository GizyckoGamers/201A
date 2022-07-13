const Constants = preload("Constants.gd")
const Enemy = preload("Enemy.gd")

var _enemies = []
var _textures = []

func _init():
	_load_textures()

func _load_textures():
	for link in Constants.kadra_texture_links:
		_textures.append(load(link))

func _pick_texture():
	if _textures.empty():
		return null
	
	var texture = _textures[rand_range(0, _textures.size())]
	
	_textures.erase(texture)
	
	return texture

func generate_enemy():
	var left_start = false
	if rand_range(0, 2) as int == 1:
		left_start = true
	var texture = _pick_texture()
	
	if not texture:
		return null
	
	var enemy = Enemy.new(left_start, texture)
	_enemies.append(enemy)
	
	return enemy

func get_enemies():
	return _enemies
