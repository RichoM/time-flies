extends Node2D

onready var fly_proto = preload("res://Fly.tscn")

func spawn_new_fly():
	var fly = fly_proto.instance()
	var x = 0
	if randf() < 0.5:
		x = -25
	else:
		x = get_viewport_rect().size.x + 25
	var y = rand_range(50, get_viewport_rect().size.y - 200)
	fly.global_transform.origin = get_viewport().canvas_transform.xform_inv(Vector2(x, y))
	add_child(fly)

func _on_timer_timeout():
	if get_child_count() <= 10:
		spawn_new_fly()
