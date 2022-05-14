extends Node2D

onready var ray = $ray
onready var line = $line

func _process(delta):
	var mouse_pos = get_local_mouse_position()
	line.points[1] = mouse_pos
	ray.cast_to = mouse_pos
