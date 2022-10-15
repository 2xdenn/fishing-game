@tool
extends Control

@onready var mainGame = preload("res://scenes/world.tscn").instantiate()
@onready var start = get_node("%StartButton")
@onready var options = get_node("%OptionsButton")
@onready var quit = get_node("%QuitButton")
@onready var menuCam = get_node("%MenuCamAnimation")
@onready var menuTheme = get_node("%MainMenuTheme")
@onready var titleAnim = get_node("%TitleAnimation")

func _ready():
	
	var startButtonPress = func():
		queue_free()
		get_tree().get_root().add_child(mainGame)
	start.button_down.connect(startButtonPress)
	
	options.button_down.connect(func() : print("options"))
	quit.button_down.connect(func() : get_tree().quit())
	menuCam.play("world_rotate")
	titleAnim.play("title_breathe")



