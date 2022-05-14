extends Area2D

var time = 0
var y

onready var freq = rand_range(2, 3)
onready var amp = rand_range(10, 30)
onready var vel = rand_range(25, 50)

func _ready():
	y = position.y
	if randf() < 0.5:
		vel *= -1

func _process(delta):
	time += delta
	position.y = y + sin(time * freq) * amp
	position.x += vel * delta
	
	var screen_pos = get_viewport().canvas_transform.xform(global_position)
	var screen_rect = get_viewport_rect()
	if vel > 0 and screen_pos.x > screen_rect.size.x + $sprite.texture.get_width():
		position.x *= -1
	if vel < 0 and screen_pos.x < 0 - $sprite.texture.get_width():
		position.x *= -1
