extends Node2D

export var RED : Color = Color("fbaba4")
export var GREEN : Color = Color("bfdac4")

func show_msg(msg, color):
	$msg/label.text = msg
	modulate = color
	$player.play("evaporate")
	
func _on_player_animation_finished(anim_name):
	get_parent().remove_child(self)
