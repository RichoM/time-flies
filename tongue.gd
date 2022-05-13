extends Node2D

enum {IDLE, FWD, BWD}
var state =  IDLE
var target : Vector2
var vel : Vector2


onready var line = $line

func _ready():
	line.points[1] = Vector2.ZERO

func is_idle():
	return state == IDLE

func set_target(point):
	if state != IDLE: return
	var screen_pos = get_viewport().canvas_transform.xform(global_position)
	target = point - screen_pos
	vel = target.normalized() * 200
	state = FWD
	line.points[1] = Vector2.ZERO
	
func _process(delta):
	line.visible = !is_idle()
	if state == FWD:
		line.points[1] += (vel * delta)
		if (target.distance_to(line.points[1]) < 10):
			state = BWD
	if state == BWD:
		line.points[1] -= (vel * delta)
		if (Vector2.ZERO.distance_to(line.points[1]) < 10):
			state = IDLE
	
