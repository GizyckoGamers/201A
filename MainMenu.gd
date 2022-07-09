extends Control

func _ready():
	if OS.get_name() == "HTML5":
		OS.set_window_fullscreen(true) 

func _on_ButtonPlywanie_pressed():
	get_tree().change_scene("res://minigames/swimming/MainScene.tscn")


func _on_ButtonUciekanie_pressed():
	get_tree().change_scene("res://minigames/korytarz/korytarz - main.tscn")


func _on_ButtonJezdzenie_pressed():
	get_tree().change_scene("res://minigames/maciek_1/main.tscn")
