extends Node2D

onready var tongue : Line2D = $tongue as Line2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	var mouse_position = tongue.get_local_mouse_position()
	tongue.points[1] = mouse_position
	
