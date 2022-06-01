extends Area2D

export var points = -30

var time = 0
var y

var flying_away = Vector2.ZERO

onready var freq = rand_range(2, 4)
onready var amp = rand_range(20, 30)
onready var vel = rand_range(35, 60)

func _ready():
	get_parent().bee_count += 1
	y = position.y
	if position.x > 0:
		vel *= -1
	$sprite.flip_h = vel > 0

func _process(delta):
	if flying_away != Vector2.ZERO:
		position += flying_away * delta
		scale.x += 2*delta
		scale.y += 2*delta
		modulate.a -= delta
		if modulate.a <= 0.01:
			get_parent().bee_count -= 1
			get_parent().remove_child(self)
			
		return
		
	time += delta
	position.y = y + sin(time * freq) * amp
	position.x += vel * delta
	
	var screen_pos = get_viewport().canvas_transform.xform(global_position)
	var screen_rect = get_viewport_rect()
	if vel > 0 and screen_pos.x > screen_rect.size.x + 25:
		get_parent().bee_count -= 1
		get_parent().remove_child(self)
	elif vel < 0 and screen_pos.x < 0 - 25:
		get_parent().bee_count -= 1
		get_parent().remove_child(self)

func fly_away():
	set_process(true)
	rotation_degrees = 0
	flying_away = Vector2(rand_range(-500, 500), rand_range(-500, -50))
	$sprite.flip_h = flying_away.x < 0
