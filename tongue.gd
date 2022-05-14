extends Node2D

enum {IDLE, FWD, BWD}
var state =  IDLE
var target : Vector2
var vel : Vector2

export var speed = 500
onready var line = $line
onready var tip = $tip

var frog
onready var bugs = []

func _ready():
	line.points[1] = Vector2.ZERO
	frog = get_parent()

func is_idle():
	return state == IDLE

func set_target(point):
	if state != IDLE: return
	var screen_pos = get_viewport().canvas_transform.xform(global_position)
	target = point - screen_pos
	vel = target.normalized() * speed
	state = FWD
	line.points[1] = Vector2.ZERO
	
func _process(delta):
	line.visible = !is_idle()
	tip.visible = line.visible
	if state == FWD:
		line.points[1] += (vel * delta)
		if (target.distance_to(line.points[1]) < 10):
			state = BWD
	if state == BWD:
		line.points[1] -= (vel * delta)
		if (Vector2.ZERO.distance_to(line.points[1]) < 10):
			state = IDLE
			eat_bugs()
	tip.position = line.points[1]
	for bug in bugs:
		bug["node"].global_position = tip.global_position + bug["offset"]

func eat_bugs():
	for bug in bugs:
		frog.eat(bug["node"])
	bugs.clear()

func _on_tip_area_entered(area):
	area.set_deferred("monitorable", false)
	area.rotate(rand_range(0, TAU))
	area.modulate = Color.red
	area.z_index = 100
	area.set_process(false)
	bugs.append({
		"offset": (area.global_position - tip.global_position) / 5,
		"node": area,
	})
