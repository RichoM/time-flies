extends Node2D

func show_msg(msg, color):
	$msg/label.text = msg
	modulate = color
	$player.play("evaporate")
	
func _on_player_animation_finished(anim_name):
	get_parent().remove_child(self)
