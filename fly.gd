extends Area2D

export var points = 10 

var time = 0
var y

var flying_away = Vector2.ZERO

onready var freq = rand_range(2, 3)
onready var amp = rand_range(10, 30)
onready var vel = rand_range(60, 100)

func _ready():
	y = position.y
	if position.x > 0:
		vel *= -1
	$sprite.flip_h = vel < 0

func _process(delta):
	if flying_away != Vector2.ZERO:
		position += flying_away * delta
		scale.x += 2*delta
		scale.y += 2*delta
		modulate.a -= delta
		if modulate.a <= 0.01:
			get_parent().remove_child(self)
		return
		
	time += delta
	position.y = y + sin(time * freq) * amp
	position.x += vel * delta
	
	var screen_pos = get_viewport().canvas_transform.xform(global_position)
	var screen_rect = get_viewport_rect()
	if vel > 0 and screen_pos.x > screen_rect.size.x + $sprite.texture.get_width():
		position.x *= -1
	if vel < 0 and screen_pos.x < 0 - $sprite.texture.get_width():
		position.x *= -1

func fly_away():
	set_process(true)
	rotation_degrees = 0
	flying_away = Vector2(rand_range(-500, 500), rand_range(-500, -50))
