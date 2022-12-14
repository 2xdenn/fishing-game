extends Node3D

signal chargeBar(boolean)
signal showBar(boolean)
@onready var power_level = 0

@onready var expBar = get_node("/root/UnderwaterTestWorld/Player/ExperienceBar")

var freezeCast = false
var canCast = true
var stopRelease = false

var canClick = false
var caughtFish = false
var canResetPlayer = false
@onready var pickFish = get_node("/root/UnderwaterTestWorld/Player/Neck/PickFish")
@onready var fishInfo = get_node("/root/UnderwaterTestWorld/Player/Neck/PickFish/FishInfo")

@export var rod : Node3D
@export var pull_back_time : float
@export var pull_back_angle : float
@export var cast_time : float
@export var cast_angle : float

@onready var lp = get_node("%LaunchPoint")
@onready var bp = get_node("/root/UnderwaterTestWorld/BobberPositioner")
@onready var bobber = preload("res://scenes/default_bobber.tscn")
@onready var cosmeticBobber := $BambooRod/starter_bobber
@onready var bambooRod := $BambooRod
@onready var b = null
@onready var bobberActive = false
@onready var waitingForBite = false
var pos = 0

@onready var fishing_minigame = preload("res://scenes/fishing_minigame.tscn")
@onready var minigame = null
var MinigameWon = false
var minigameActive = false


func launchBobber(Bob):
	pos = lp.global_position
	bp.global_transform.origin = pos
	bp.add_child(b)
	Bob.shoot = true 
	Bob.power = power_level

func _input(event):
	if freezeCast == false:
		
		# pull fishing rod back
		if Input.is_action_just_pressed("left_click") && canCast:
		
			emit_signal("chargeBar", true)
			emit_signal("showBar", true)
			animatePull()
			stopRelease = false
			waitingForBite = false
			cosmeticBobber.show()
			bambooRod.show()
			
		# release fishing rod
		if event.is_action_released("left_click") && !stopRelease && canCast:
			emit_signal("chargeBar", false)
			emit_signal("showBar", true)
			animateCast()
			print("release bobber!")
			b = bobber.instantiate()
			bobberActive = true
			launchBobber(b)
			canCast = false
			cosmeticBobber.hide()
			$CastSound.play()
			
		# functions to reel in when the bobber is in the water
		if Input.is_action_just_pressed("left_click") && !canCast:
			
			animatePull()
			stopRelease = false
			print("reel in")
		if event.is_action_released("left_click") && !stopRelease && !canCast:

			animateCast()
			
		#reset animation
		if Input.is_action_just_pressed("right_click") && !waitingForBite:
			animateIdle()
			stopRelease = true
			canCast = true
			waitingForBite = true
			cosmeticBobber.show()
			if(bobberActive):
				b.queue_free()
				bobberActive = false
			
	if freezeCast == true:
		
		# after catching the fish player can right click to return to an idle state
		if canResetPlayer && Input.is_action_just_pressed("right_click"):
			pickFish.deleteFish()
			fishInfo.resetText()
			#reset FishingRod
			print("reset")
			canResetPlayer = false
			freezeCast = false
			canCast = true
			
func _physics_process(_delta):
	
	# activates when you succesfully beat the minigame
	if(MinigameWon):
		
		MinigameWon = false
		canClick = false
		canResetPlayer = true
		freezeCast = true
		minigameActive = false
		
		
		# spawn fish from PickFish function
		pickFish.fishCall()
		
		# gain an amount of exp based on the fish you catch
		if(pickFish.getFishRarity() == "Common"):
			expBar.gain_exp(1)
		if(pickFish.getFishRarity() == "Uncommon"):
			expBar.gain_exp(3)
		if(pickFish.getFishRarity() == "Rare"):
			expBar.gain_exp(5)
		
		# calls FishInfo control node to update the text to the correct fish information
		fishInfo.displayFishInfo()
		
	# activates if you lose the fishing minigame
	elif(minigameActive && MinigameWon == false):
		
		MinigameWon = false
		canClick = false
		canResetPlayer = true
		freezeCast = true
		minigameActive = false
	
	
	# activates if you succesfully hook a fish. canClick gets activated in 
	# default_bobber function
	if Input.is_action_just_pressed("right_click") && canClick:
		
		$CatchSound.play()
		
		var minigame = fishing_minigame.instantiate()
		add_child(minigame)
		minigame.fishBite = true
		minigameActive = true
		
		animateIdle()
		bambooRod.hide()
		
		freezeCast = true

func animatePull():
	var tween = create_tween()
	tween.tween_property(rod, "rotation", Vector3(pull_back_angle, 0, 0), pull_back_time).set_trans(Tween.TRANS_SINE)
func animateCast():
	var tween = create_tween()
	tween.tween_property(rod, "rotation", Vector3(cast_angle, 0, 0), cast_time).set_trans(Tween.TRANS_SINE)
func animateIdle():
	var tween = create_tween()
	tween.tween_property(rod, "rotation", Vector3(0, 0, 0), 0)
func animateBobberReelIn():
	# b is the bobber instance in the scene
	var tween = create_tween()
	tween.tween_property(b, "position", Vector3(0, 0, 0), 0)

# gets the power level of the cast from the rod control method
func _on_rod_control_bar_power(integer):
	print(str(integer))
	power_level = integer
	
