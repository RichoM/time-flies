extends Node2D

export(NodePath) var frogs_path

onready var index = 0
onready var frogs = get_node(frogs_path).get_children()

func _ready():
	get_current_frog().set_current(true)

func get_current_frog(): 
	return frogs[index % frogs.size()]

func next_frog():
	get_current_frog().set_current(false)
	index += 1
	get_current_frog().set_current(true)

func _input(event):
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
		
func _process(delta):
	check_tongues_crossing()
