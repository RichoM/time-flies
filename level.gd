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
