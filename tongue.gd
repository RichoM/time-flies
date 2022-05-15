extends Node2D

signal state_changed(prev_state, new_state)

enum {IDLE, FWD, BWD, STUCK}
var state =  IDLE
var target : Vector2
var vel : Vector2

export var speed = 500
onready var line = $line
onready var tip = $tip

var frog
onready var bugs = []

var sticky = true

func _ready():
	line.points[1] = Vector2.ZERO
	frog = get_parent()

func is_idle():
	return state == IDLE
	
func set_state(s):
	var prev = state
	state = s
	emit_signal("state_changed", prev, state)

func set_target(point):
	if state != IDLE: return
	var screen_pos = get_viewport().canvas_transform.xform(global_position)
	target = point - screen_pos
	vel = target.normalized() * speed
	set_state(FWD)
	line.points[1] = Vector2.ZERO
	$sfx.play()
	
func _process(delta):
	line.visible = !is_idle()
	tip.visible = line.visible
	if state == FWD:
		line.points[1] += (vel * delta)
		if (line.points[0].distance_to(line.points[1]) > 450):
			set_state(BWD)
	if state == BWD:
		line.points[1] -= (vel * delta)
		if (Vector2.ZERO.distance_to(line.points[1]) < 10):
			set_state(IDLE)
			sticky = true
			eat_bugs()
	tip.position = line.points[1]
	tip.rotation = (line.points[1] - line.points[0]).angle()
	for bug in bugs:
		bug["node"].global_position = tip.global_position + bug["offset"]

func eat_bugs():
	var actual_bugs = []
	for bug in bugs:
		actual_bugs.append(bug["node"])
	frog.eat(actual_bugs)
	bugs.clear()

func _on_tip_area_entered(area):
	if !sticky: return
	area.set_deferred("monitorable", false)
	area.rotate(rand_range(0, TAU))
	area.z_index = 100
	area.set_process(false)
	bugs.append({
		"offset": (area.global_position - tip.global_position) / 5,
		"node": area,
	})
	
func release_bugs():
	for bug in bugs:
		var node = bug["node"]
		node.fly_away()
	bugs.clear()

func tongue_crossing_at(point):
	sticky = false
	set_state(STUCK)
	release_bugs()
	yield(get_tree().create_timer(0.1), "timeout")
	set_state(BWD)
	vel *= 3
