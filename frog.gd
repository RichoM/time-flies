extends Node2D

onready var tongue = $tongue
onready var body = $body
onready var marker = $marker

func _process(_delta):
	if tongue.is_idle():
		body.animation = "closed"
	else:
		body.animation = "open"
		
func set_target(point):
	tongue.set_target(point)
	
func eat(bug):
	bug.get_parent().remove_child(bug)
	# TODO(Richo): Score!

func set_current(val):
	marker.visible = val
