extends Node3D

func _process(delta):
	if get_node("%AnimationPlayer").get_current_animation() == "cast":
		hide()
	if get_node("%AnimationPlayer").get_current_animation() == "pull":
		show()
