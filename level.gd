extends Node2D

export(NodePath) var frogs_path

export(float) var time = 60 * 1000

var begin_time
var started = false
var total_score = 0

onready var index = 0
onready var frogs = get_node(frogs_path).get_children()

func _ready():
	get_current_frog().set_current(true)
	for frog in frogs:
		frog.connect("bugs_eaten", self, "update_score")
	begin_start_sequence()

func update_score(frog, bugs : Array):
	# TODO(Richo): Change score by bug type
	var count = bugs.size()
	var score
	var multiplier
	if count > 0:
		score = count * 10
		multiplier = count
	else:
		score = -10
		multiplier = 1
	frog.display_points(score, multiplier)
	total_score += score*multiplier
	if total_score < 0:
		total_score = 0
	$GUI/score.text = str(total_score)

func begin_start_sequence():
	$AnimationPlayer.play("start_sequence")

func start_game():
	started = true
	begin_time = OS.get_ticks_msec()
	
func _process(delta):
	check_tongues_crossing()
	if started:
		var elapsed = OS.get_ticks_msec() - begin_time
		var remaining = time - elapsed
		display_remaining(remaining)
	
func display_remaining(remaining):
	if remaining < 0:
		$GUI/remaining_time.text = "00:00"
	else:
		var minutes = int(remaining / 60 / 1000)
		var seconds = int(remaining / 1000) % 60
		var miliseconds = int(remaining) % 1000
		$GUI/remaining_time.text = ("%02d" % minutes) + (":%02d" % seconds)

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
		frog.set_target(event.position)
		next_frog()
		while get_current_frog().disabled and get_current_frog() != frog:
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
