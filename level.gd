extends Node2D

export(NodePath) var frogs_path

export(float) var time = 60 * 1000

var begin_time
var started = false
var total_score = 0

const SCORE_FILE_PATH = "user://max_score.bin"
var max_score = 0

onready var index = 0
onready var frogs = get_node(frogs_path).get_children()

func _ready():
	randomize()
	read_max_score()
	for frog in frogs:
		frog.connect("bugs_eaten", self, "update_score")
	begin_start_sequence()
	
func read_max_score():
	var score_file = File.new()
	var error = score_file.open(SCORE_FILE_PATH, File.READ)
	
	max_score = score_file.get_64()
	score_file.close()
	$HUD/max_score.text = str(max_score)
	
func write_max_score(score):
	max_score = score
	var score_file = File.new()
	score_file.open(SCORE_FILE_PATH, File.WRITE)
	score_file.store_64(max_score)
	score_file.close()
	

func update_score(frog, bugs : Array):
	var count = bugs.size()
	var score = 0
	var multiplier
	if count > 0:
		var damage = 0
		for bug in bugs:
			if bug.points < 0:
				damage += bug.points
			score += bug.points
		if damage != 0:
			score = damage
			multiplier = 1
		else:
			multiplier = count
	else:
		score = -10
		multiplier = 1
	frog.display_points(score, multiplier)
	var extra_score = score*multiplier
	if extra_score >= 100:
		time += 10000
		var extra_time = preload("res://extra_time.tscn").instance()
		extra_time.position = $HUD/extra_time.position
		extra_time.show_seconds(10)
		$HUD.add_child(extra_time)
	total_score += extra_score
	if total_score < 0:
		total_score = 0
	$HUD/score.text = str(total_score)
	if total_score > max_score:
		$HUD/score.add_color_override("font_color", Color("68db7d"))

func begin_start_sequence():
	$AnimationPlayer.play("start_sequence")

func start_game():
	started = true
	begin_time = OS.get_ticks_msec()
	get_current_frog().set_current(true)
	
func _process(delta):
	check_tongues_crossing()
	if started:
		var elapsed = OS.get_ticks_msec() - begin_time
		var remaining = time - elapsed
		display_remaining(remaining)
		if remaining <= 0:
			end_game()
		elif remaining <= 10000:
			$music.pitch_scale = 1.05
			$HUD/clock.modulate = Color("fbaba4")
			$HUD/remaining_time.add_color_override("font_color", Color("f87a6f"))
		else:
			$music.pitch_scale = 1.0
			$HUD/clock.modulate = Color.white
			$HUD/remaining_time.add_color_override("font_color", Color.white)
	if begin_time != null:
		var t = (OS.get_ticks_msec() - begin_time) / 1000.0
		$GameOver/RestartButton.rotation_degrees = sin(t*2) * 2.5
			
func end_game():
	started = false
	$HUD.visible = false
	if total_score > max_score:
		write_max_score(total_score)
		$GameOver/message_top.text = "NEW HIGHSCORE!"
	else:
		$GameOver/message_top.text = "GAME OVER"
	$GameOver/message_bottom.text = "Score: " + str(total_score)
	$GameOver.visible = true
	$fly_spawner.visible = false
	$frogs.visible = false
	$music.stop()
	$gameover_sfx.play()
	
func restart():
	get_tree().reload_current_scene()
	
func display_remaining(remaining):
	if remaining < 0:
		$HUD/remaining_time.text = "00:00"
	else:
		var minutes = int(remaining / 60 / 1000)
		var seconds = int(remaining / 1000) % 60
		var miliseconds = int(remaining) % 1000
		$HUD/remaining_time.text = ("%02d" % minutes) + (":%02d" % seconds)

func get_current_frog(): 
	return frogs[index % frogs.size()]

func next_frog():
	get_current_frog().set_current(false)
	index += 1
	get_current_frog().set_current(true)

func _input(event):
	if !started: return
	if event is InputEventMouseButton and event.is_pressed():
		var frog = get_current_frog()
		if frog.set_target(event.position):
			next_frog()
		
func check_tongues_crossing():
	for i in range(frogs.size() - 1):
		var f0 = frogs[i]
		for j in range(i + 1, frogs.size()):
			var f1 = frogs[j]
			var s0 = f0.get_tongue_segment()
			var s1 = f1.get_tongue_segment()
			var collision = Geometry.segment_intersects_segment_2d(s0[0], s0[1], s1[0], s1[1])
			if collision:
				f0.tongue_collision(collision)
				f1.tongue_collision(collision)

func _on_restart_button_pressed():
	restart()
