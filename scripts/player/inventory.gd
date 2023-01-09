extends Control

func _input(event):
	
	# activates when opening the inventory with 'e'
	if event.is_action_pressed("inventory"):
		print("open inventory")


