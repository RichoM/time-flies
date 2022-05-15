extends Node2D

onready var tongue = $tongue
onready var body = $body
onready var marker = $marker

export(float) var height = 0

var disabled = false

signal bugs_eaten(frog, bugs)

func set_target(point):
	tongue.set_target(point)
	var target = get_viewport().canvas_transform.xform_inv(point)
	if target.x < position.x:
		body.flip_h = true
		tongue.position.x = -19
	else:
		body.flip_h = false
		tongue.position.x = 19
	
	
func eat(bugs):
	var penalty = false
	for bug in bugs:
		if bug.points < 0:
			penalty = true
	for bug in bugs:
		if penalty:
			bug.fly_away()
		else:
			bug.get_parent().remove_child(bug)
	emit_signal("bugs_eaten", self, bugs)

func set_current(val):
	marker.visible = val

func get_tongue_segment():
	var line : Line2D = tongue.line
	var p0 = get_viewport().canvas_transform.xform(line.global_position + line.points[0])
	var p1 = get_viewport().canvas_transform.xform(line.global_position + line.points[1])
	return [p0, p1]

func tongue_collision(point):
	if !tongue.sticky: return
	tongue.tongue_crossing_at(point)
	take_damage(false)
	
func take_damage(hurt : bool):
	$hurt_sfx.play(0)
	body.play("hurt" if hurt else "sad")
	disabled = true
	yield(get_tree().create_timer(2), "timeout")
	modulate = Color.white
	disabled = false
	body.animation = "closed"
	
func display_points(points, multiplier):
	var point_msg = preload("res://points.tscn").instance()
	add_child(point_msg)
	point_msg.position = $points.position
	var msg = str(points)
	if multiplier > 1:
		msg += "\nx" + str(multiplier)
	point_msg.show_msg(msg, Color.green if points > 0 else Color.red)
	if points < 0:
		take_damage(points < -10)
	else:
		$eat_sfx.play(0)
		body.play("eating")
		yield(get_tree().create_timer(1), "timeout")
		body.play("closed")
	
func appear():
	$player.play("appear", -1, 0.75)

func _process(delta):
	body.material.set("shader_param/displacement", Vector2(0, height))
	if Input.is_action_just_pressed("ui_accept"):
		display_points(int(rand_range(-100, 100)), 2)

func _on_tongue_state_changed(prev_state, new_state):
	if disabled: return
	if new_state == tongue.IDLE:
		body.animation = "closed"
	elif new_state == tongue.FWD or new_state == tongue.BWD:
		body.animation = "open"
