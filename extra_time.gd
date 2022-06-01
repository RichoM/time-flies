extends Node2D

func show_seconds(seconds):
	$seconds/label.text = "+" + str(seconds)
	$player.play("evaporate")

func _on_player_animation_finished(anim_name):
	get_parent().remove_child(self)
