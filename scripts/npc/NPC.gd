extends Node3D

func _on_area_3d_body_entered(body):
	if body.name == "Player":
		print("activate shop")
		get_tree().paused = true
		# make player idle animation
		#get_node("../Player/Animations").play("Idle")
		get_node("Shop/Anim").play("TransIn")
