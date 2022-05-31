extends Node2D

onready var begin_time = OS.get_ticks_msec()

func _process(delta_):
	var t = (OS.get_ticks_msec() - begin_time) / 1000.0
	$PlayButton.rotation_degrees = sin(t*2) * 2.5
	
func _on_play_button_pressed():
	get_tree().change_scene("res://Level.tscn")
