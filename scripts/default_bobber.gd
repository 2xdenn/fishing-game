extends RigidBody3D

@onready var waterFoam = get_node("%Water_foam")
@onready var waterMist = get_node("%Water_mist")
@onready var splash = get_node("%WaterSplashEmitter")

var inputVel = 0
var power = 0
@export var speed : float
var shoot = false
var canClick = false

@export var catchWindowWaitTime : float
@onready var lp = get_node("/root/UnderwaterTestWorld/Player/Neck/FishingRod/LaunchPoint")
@onready var catchTimer = get_node("CatchTimer")
@onready var catchWindowTimer = get_node("CatchWindowTimer")
@onready var exclaim = get_node("%ExclamationEmitter")
@export var bobberMesh : MeshInstance3D
@export var exclamationSound : AudioStreamPlayer3D
@onready var caughtFish = false
@onready var canResetPlayer = false
@onready var fishingRod = get_node("/root/UnderwaterTestWorld/Player/Neck/FishingRod/")

# triggers when bobber enters water and returns a random wait time
func calculateBobTime():
	
	#between these 2 amounts. if min = -1 and max = 1 it will always print 0
	var bob_time_minimum = 2
	var bob_time_maximum = 8
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var my_random_number = int(rng.randf_range(bob_time_minimum, bob_time_maximum))
	print(my_random_number)
	return my_random_number

#shooting bobber physics
func shootBob(delta):
	
	
	inputVel = lp.global_transform.basis.z.normalized()
	apply_impulse(inputVel * power * speed * delta)

func _physics_process(delta):

	# shoots bobber when shoot is set to true by fishing_rod script
	if(shoot):
		shootBob(delta)
		waterFoam.hide()
		waterMist.hide()
	else:
		set_sleeping(true)

# checks if bobber area touches anything, freezes if it does
func _on_bobber_area_body_entered(body):
	
	# stops the shooting function in physics_process()
	shoot = false
	
	# activates if bobber touches an object in the "Water" group
	if body.is_in_group("Water"):
		# sends a signal to the fishing rod script to generate the fish
		
		
		catchTimer.set_wait_time(calculateBobTime())
		catchTimer.start()
		# activate effects for when the bobber lands in water
		$SplashSound.play()
		makeFoam()
		makeSplash()
		makeMist()
		bobLanding()
	# activates if bobber touches anything else
	else:
		# add effects for when it lands on different things i.e trees, grass, NPC's
		print("not in water")

# activates when a fish bites
func _on_catch_timer_timeout():
	
	exclaim.set_emitting(true)
	fishingRod.canClick = true
	$BiteSound.play()
	#the time value of this should be dependent on the precalculated fish
	catchWindowTimer.set_wait_time(catchWindowWaitTime)
	catchWindowTimer.start()
	bobBite()

# timer creates a small window of time when you can click and if succesfull 
# you will catch a fish, if not nothing happens
func _on_catch_window_timer_timeout():
	fishingRod.canClick = false
	if(caughtFish == false):
		print("missed")
		bobIdle()
		catchTimer.set_wait_time(calculateBobTime())
		catchTimer.start()

func deleteBobber():
	queue_free()
func makeFoam():
	waterFoam.show()
	get_node("%WaterFoamPlayer").play("Fade")
func makeSplash():
	splash.set_emitting(true)
func makeMist():
	waterMist.show()
	get_node("%WaterMistPlayer").play("Mist")
func bobBite():
	get_node("%BobberPlayer").play("BobFishBite")
func bobLanding():
	get_node("%BobberPlayer").play("BobWaterLanding")
func bobIdle():
	get_node("%BobberPlayer").play("BobIdle")

# Idle animation play after bobber water landing animation
func _on_bobber_player_animation_finished(BobWaterLanding):
	bobIdle()
