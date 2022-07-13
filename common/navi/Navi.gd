extends Node2D

func _input(event):
	if event.is_action_pressed("full_screen"):
		OS.set_window_fullscreen(!OS.window_fullscreen)
	elif event.is_action_pressed("escape"):
		OS.set_window_fullscreen(false)
	elif event.is_action_pressed("back"):
		get_tree().change_scene("res://MainMenu.tscn")
	elif event.is_action_pressed("game1"):
		get_tree().change_scene("res://minigames/swimming/MainScene.tscn")
	elif event.is_action_pressed("game2"):
		get_tree().change_scene("res://minigames/korytarz/korytarz - main.tscn")
	elif event.is_action_pressed("game3"):
		get_tree().change_scene("res://minigames/rejser/scenes/Track1.tscn")
	elif event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
