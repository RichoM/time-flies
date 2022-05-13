extends Node2D

onready var tongue = $tongue
onready var body = $body

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(_delta):
	if tongue.is_idle():
		body.animation = "closed"
	else:
		body.animation = "open"
	
func _input(event):
	if event is InputEventMouseButton:
		tongue.set_target(event.position)
		print("MOUSE_POS: ", event.position)
		var screen_pos = get_viewport().canvas_transform.xform(tongue.position)
		print("SCREEN_POS: ", screen_pos)
	
