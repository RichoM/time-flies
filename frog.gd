extends Node2D

onready var tongue = $tongue
onready var body = $body

func _process(_delta):
	if tongue.is_idle():
		body.animation = "closed"
	else:
		body.animation = "open"
	
func _input(event):
	if event is InputEventMouseButton:
		tongue.set_target(event.position)
	
func eat(bug):
	bug.get_parent().remove_child(bug)
	# TODO(Richo): Score!
