extends Node3D

@onready var gameTime = 0

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit() # Quits the game
		

