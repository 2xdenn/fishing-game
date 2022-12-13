extends Control

@onready var bar = get_node("%ExpBar")
@onready var level_display = get_node("%Level")
@onready var exp_display = get_node("%ExpDisplay")
@onready var level : int = 1

func _ready():
	level_display.text = str(level)
	exp_display.text = str(experience) + " / " + str(experience_required)

func _input(event):
	if Input.is_action_just_pressed("left_click"):
		gain_exp(3)
		

var experience = 0 
var experience_total = 0 
var experience_required = get_required_exp(level + 1)

func get_required_exp(level):
	return round(pow(level, 1.8) + level * 4)
	
func gain_exp(amount):
	experience_total += amount
	experience += amount
	
	exp_display.text = str(experience) + " / " + str(experience_required)
	
	while experience >= experience_required:
		experience -= experience_required
		level_up()
		
func level_up():
	level += 1
	experience_required = get_required_exp(level + 1)
	
	print("Level Up!")
	level_display.text = (str(level))
	#bar.max_value = experience_required
	#experience_total = 0
