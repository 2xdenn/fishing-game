extends Control


@onready var timer = get_node("%ChargeTimer")
@onready var launchText = get_node("%LaunchText")
@onready var ShotTypeText = get_node("%ShotTypeText")
var lockInTime = 2

# physically interacts with bar by hiding it when uneeded and changing its value
# when charging

@onready var bar = $ChargeMeter

func _ready():
	bar.hide()
	launchText.hide()
	ShotTypeText.hide()

	
func _on_starter_rod_charge(value):
	bar.value = value
	
func _on_starter_rod_show_bar(boolean):
	if(boolean):
		timer.start()
		bar.show()
	else:
		timer.set_wait_time(lockInTime)
		launchText.show()
		ShotTypeText.show()
		
func _on_charge_timer_timeout():
		bar.hide()
		launchText.hide()
		ShotTypeText.hide()
	


