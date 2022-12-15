extends Control

@onready var bar = get_node("%ExpBar")
@onready var level_display = get_node("%Level")
@onready var exp_display = get_node("%ExpDisplay")
@onready var level : int = 1

@onready var experience = 0 
@onready var experience_total = 0 
@onready var experience_required = get_required_exp(level + 1)

func _ready():
	level_display.text = str(level)
	exp_display.text = str(experience) + " / " + str(experience_required)
	bar.max_value = experience_required
	bar.value = experience

# takes a point from a graph and rounds it to give you however much exp is required for the next level
func get_required_exp(level):

	return round(pow(level, 1.8) + level * 4)

# activate this function when you want the player to gain exp
func gain_exp(amount):
	
	experience_total += amount
	experience += amount
	
	exp_display.text = str(experience) + " / " + str(experience_required)
	bar.max_value = experience_required
	bar.value = experience
	
	# detects when you have enough exp to level up
	while experience >= experience_required:
		experience -= experience_required
		level_up()
		
# activates when your experience is more than or equal to the expereince required
func level_up():
	level += 1
	experience_required = get_required_exp(level + 1)
	
	# updates the level and experience bar when you level up
	level_display.text = (str(level))
	exp_display.text = str(experience) + " / " + str(experience_required)
	bar.max_value = experience_required
	bar.value = experience
	
	$LevelUpSound.play()
	
