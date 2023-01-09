extends Node3D

@onready var displayText = get_node("%TimeDisplay")
@onready var skyAnimation = get_node("%DayNightAnimation")
var seasons = ["Spring", "Summer", "Fall", "Winter"]

var displayTime = 0.0
var numberOfDays = 0
var seconds
@onready var hour = 0


func _ready():
	skyAnimation.play("day_night_animation")
	displayTime = 0
	
	
func _process(delta):
	
	#displayText.text = str(hours) + " : " + str(mins)
	displayTime += delta

	seconds = str(int(displayTime))
	
	if(seconds == "6"):
		#seconds = "0"
		displayTime = 0
		hour += 1
	
	# Reads out the time on screen
	displayText.text = str(hour) + " : " + seconds + "0"
	

	if(displayTime == 240):
		endOfDay()

func generateDay(season):
	
	if(season == "Spring"):
		print("Spring")
	if(season == "Summer"):
		print("Summer")
	if(season == "Fall"):
		print("Fall")
	if(season == "Winter"):
		print("Winter")
	
	
func endOfDay():
	
	numberOfDays += 1
	displayTime = 0
