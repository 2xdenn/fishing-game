extends RigidBody3D

var speed = 15
var power = 0
var shoot = false
var inputVel = 0
var canClick = false
var caughtFish : bool = false
var bob_time = 0
@onready var bobberMesh = get_node("%starter_bobber")
@onready var lp = get_node("/root/World/Player/Neck/starter_rod/LaunchPoint")
@onready var starterRod = get_node("/root/World/Player/Neck/starter_rod")
@onready var fish = preload("res://scenes/fish_rigid_body.tscn")
@onready var waterFoam = get_node("%Water_foam")
@onready var waterMist = get_node("%Water_mist")
@onready var splash = get_node("%WaterSplashEmitter")
@onready var exclaim = get_node("%ExclamationEmitter")
@onready var spawnTimer = get_node("%SpawnTimer")
@onready var hitWindowTimer = get_node("%HitWindowTimer")
@export var hit_window_time = 1
var f = null

func _physics_process(delta):
	if(shoot):
		shootBob(delta)
	else:
		set_sleeping(true)
	
	#if you succesfully time your click, this will activate
	if Input.is_action_just_pressed("right_click") && canClick:
		print("catch!")
		caughtFish = true
		$CatchSound.play()
		f = fish.instantiate()
		add_child(f)
		f.launch = true
		starterRod.displayCatchText()
		canClick = false


#physics of the bobber
func shootBob(delta):
	
	inputVel = lp.global_transform.basis.z.normalized()
	apply_impulse(inputVel * power * speed * delta)
	waterFoam.hide()
	waterMist.hide()

func makeFoam():
	waterFoam.show()
	get_node("%WaterFoamPlayer").play("Fade")

func makeSplash():
	splash.set_emitting(true)

func makeMist():
	waterMist.show()
	get_node("%WaterMistPlayer").play("Mist")

func exclamationPoint():
	
	exclaim.set_emitting(true)

#creates both the bob timer and hit window timer
func create_timer(time, TimerNode):
		TimerNode.set_wait_time(time)
		TimerNode.start()

#function to calculate and set bob time to correct random number
func calculateBobTime():
	#between these 2 amounts aka. if min = -1 and max = 1 it will always print 0
	var bob_time_minimum = 2
	var bob_time_maximum = 8
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var my_random_number = int(rng.randf_range(bob_time_minimum, bob_time_maximum))
	print(my_random_number)
	bob_time = my_random_number

#function activates when the fish bites
func _on_spawn_timer_timeout():
	canClick = true
	#creates a timer after the fish bite which is your window to click
	create_timer(hit_window_time, hitWindowTimer)
	get_node("%BobberAnimationPlayer").play("bob")
	exclamationPoint()
	$BiteSound.play()

#after your window to click ends do this
func _on_hit_window_timer_timeout():
	canClick = false
	if(caughtFish == false):
		print("missed")
		calculateBobTime()
		create_timer(bob_time, spawnTimer)


#checks if the bobber is in the water and if it is stop shooting 
func _on_area_3d_body_entered(body):
	shoot = false
	if body.is_in_group("Water"):
		print("in da watah")
		calculateBobTime()
		get_node("%BobberAnimationPlayer").play("landing")
		create_timer(bob_time, spawnTimer)
		$SplashSound.play()
		makeFoam()
		makeSplash()
		makeMist()
		can_sleep = true

#once the fish bites and the bob animation plays, play the idle animation after
func _on_bobber_animation_player_animation_finished(bob):
	get_node("%BobberAnimationPlayer").play("idle")

#called from starter_rod script
func hideMesh():
	bobberMesh.hide()
