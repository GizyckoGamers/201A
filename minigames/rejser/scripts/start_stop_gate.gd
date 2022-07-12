extends Node2D

const player = preload("res://minigames/rejser/scripts/kill_me.gd")

var time: float = 0.0
var sec_1_time: float = -1.0
var sec_2_time: float = -1.0
var started := false

func start_timer():
	started = true

func stop_timer():
	started = false

func as_nice_string(input: float) -> String:
	var minutes := input / 60
	var seconds := fmod(input, 60)
	var milliseconds := fmod(input, 1) * 100
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]

func _process(delta: float):
	if started:
		time += delta

func _on_main_gate_body_entered(body: Node) -> void:
	if not body is player:
		return;
	
	started = !started
	
	if !started:
		sec_2_time = time - sec_1_time
		print_debug("total time: ", as_nice_string(time))
		print_debug("sec1 time: ", as_nice_string(sec_1_time))
		print_debug("sec2 time: ", as_nice_string(sec_2_time))

func _on_sec_gate_1_body_entered(body: Node) -> void:
	sec_1_time = time
