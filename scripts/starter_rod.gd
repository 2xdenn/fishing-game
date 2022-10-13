extends Node3D

signal charge(value)
signal showBar(boolean)
@onready var bar = ("%ChargeMeter")
@onready var bobber = preload("res://scenes/bobber.tscn")
@onready var chargeLevel = 0
@onready var power = 0
@onready var lp = get_node("%LaunchPoint")
@onready var bp = get_node("%BobberPositioner")
@onready var aimcast = get_node("%AimCast")
@onready var launchText = get_node("%LaunchText")
@onready var ShotTypeText = get_node("%ShotTypeText")
@onready var goingDown = false
var inFishingMode = false
var chargeBar = false
var b = null
var bobberCount = 0
@onready var wrld = get_tree().get_root().get_node("World")
var pos = Vector3(-5,10,0)
@onready var canCast = true

func launch_bobber(b):
	pos = lp.global_position
	bp.global_transform.origin = pos
	bp.add_child(b)
	b.shoot = true 

func _input(event):
	#if left click is pressed play the pull animation and set chargebar to true
	if Input.is_action_just_pressed("left_click") && canCast:
		get_node("%AnimationPlayer").play("pull")
		#get_node("%CameraAnimationPlayer").play("camera_pull")
		chargeBar = true
		launchText.hide()
		ShotTypeText.hide()
		$ChargeUpSound.play()
		if(bobberCount == 1):
			b.queue_free()
			bobberCount = 0
	#if left click is released play the cast animation
	if event.is_action_released("left_click") && canCast:
		get_node("%AnimationPlayer").play("cast")
		#get_node("%CameraAnimationPlayer").play("camera_cast")
		$ChargeUpSound.stop()
		$ChargeDownSound.stop()
		$LockInSound.play()
		$SwingSound.play()
		b = bobber.instantiate() 
		#resets fish spawners timer
		bobberCount = 1
		launch_bobber(b)
		chargeBar = false
		goingDown = false
		#stores the power level of the bar when you let go
		power = chargeLevel
		b.power = power
		launchText.text = str(power)
		shot_type_text()
		chargeLevel = 0
		emit_signal("showBar", false)
	


func _physics_process(_delta):
	#moves the charge bar up and down from 0 to 70 and moves it back down
	#once it reaches the top, also plays the sounds of going up and down
	if(chargeBar && chargeLevel < 71 && not goingDown):
		chargeLevel += 1
		emit_signal("charge", chargeLevel)
		emit_signal("showBar", true)
		$ChargeDownSound.play()
		if(chargeLevel == 71):
			goingDown = true
	if(goingDown && chargeLevel > 0):
		chargeLevel -= 1
		emit_signal("charge", chargeLevel)
		emit_signal("showBar", true)
		$ChargeUpSound.play()
		if(chargeLevel == 0):
			goingDown = false
	

func shot_type_text():
	if(power >= 0 && power <= 45):
		ShotTypeText.text = "Misfire..."
		get_node("%UIAnimationPlayer").play("Text_Miss")	
	if(power >= 46 && power <= 60):
		ShotTypeText.text = "Try Again"
		get_node("%UIAnimationPlayer").play("Text_Miss")
	if(power >= 60 && power <= 67):
		ShotTypeText.text = "So Close!"
		get_node("%UIAnimationPlayer").play("Text_Miss")
	if(power >=68  && power <= 69):
		ShotTypeText.text = "Nice Cast!"
		get_node("%UIAnimationPlayer").play("Text_Miss")
	if(power == 70):
		ShotTypeText.text = "Perfect Cast!"
		$PerfectShotSound.play()
		get_node("%UIAnimationPlayer").play("Text_Grow")
		

#This is where screen fade is 
func displayCatchText():
		get_node("%CatchAnimationPlayer").play("catch")
		b.hideMesh()
		get_node("%UIAnimationPlayer").play("ScreenFade")

func freezeCasting():
	canCast = false

func unfreezeCasting():
	canCast = true
