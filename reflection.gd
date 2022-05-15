extends Sprite

export(NodePath) var body_path
onready var body = get_node(body_path)

func _process(delta):
	texture =  body.frames.get_frame(body.animation, body.frame)
	flip_h = body.flip_h
