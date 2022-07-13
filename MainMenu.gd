extends Control

func _on_ButtonPlywanie_pressed():
	get_tree().change_scene("res://minigames/swimming/MainScene.tscn")

func _on_ButtonUciekanie_pressed():
	get_tree().change_scene("res://minigames/korytarz/korytarz - main.tscn")

func _on_ButtonJezdzenie_pressed():
	get_tree().change_scene("res://minigames/rejser/scenes/Track1.tscn")

func _on_FullscreenButton_pressed():
		OS.set_window_fullscreen(!OS.window_fullscreen)
