extends Control

signal barPower(integer)

@onready var chargeMeter = $ChargeBar
@onready var chargeBar = false
@onready var chargeLevel = 0
@onready var goingDown = false
@export var targetCeil : int
@export var targetFloor : int
@export var freezeTimer : Timer
@export var barMax : int
@export var barMin : int
@export var chargeSpeed : int

func _ready():
	chargeMeter.hide()

func _process(_delta):

	chargeMeter.value = chargeLevel
	
	# makes the bar go up and down
	if(chargeBar):
		if(chargeLevel < barMax && not goingDown):
			chargeLevel += chargeSpeed

			if(chargeLevel == barMax):
				goingDown = true
		if(goingDown && chargeLevel > barMin):
			chargeLevel -= chargeSpeed

			if(chargeLevel == barMin):
				goingDown = false

# takes in signal from fishing rod function. true means player is left clicking,
# false means player let go of left click
func _on_fishing_rod_charge_bar(boolean):
	chargeBar = boolean
	if chargeBar:
		freezeTimer.stop()
		chargeMeter.show()
		chargeLevel = 0
		goingDown = false
	else:
		# sends signal to fishing rod to launch the bobber the correct distance
		emit_signal("barPower", chargeLevel)
		# checks after player releases what type of cast it is
		if(chargeLevel > targetFloor && chargeLevel < targetCeil):
			print("perfect catch")
			get_node("%RodUIAnimations").play("perfect_cast_text")
		else:
			#print("not quite")
			pass
		freezeTimer.start()

#after the freeze timer
func _on_freeze_meter_timer_timeout():
	chargeMeter.hide()
