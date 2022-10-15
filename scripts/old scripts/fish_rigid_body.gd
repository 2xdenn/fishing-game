extends RigidBody3D

@onready var rudd = preload("res://fish/rudd/rudd.tscn")
@onready var whale = preload("res://fish/whale/whale.tscn")
@onready var manta = preload("res://fish/manta/manta_ray.tscn")
@onready var pathFollow = get_node("%PathFollow3d")
@onready var fishSpawnPoint = get_node("%FishSpawnPoint")
@onready var fCam = get_node("%FishCam")
@onready var fishTimer = get_node("%FishTimer")
@onready var fishDisplay = get_node("%FishDisplay")
@onready var fishSize = get_node("%FishSizeDisplay")
@onready var screen_switch_time = 3.0
@onready var fishID = "Empty"
@onready var player = get_node("/root/World/Player")
@onready var rod = get_node("/root/World/Player/Neck/starter_rod")
@onready var playerCam = get_node("/root/World/Player/Neck/Camera")
@onready var postCatchCam = get_node("/root/World/Player/PostCatchCam")
@onready var postCatchCamSpawnPoint = get_node("/root/World/Player/PostCatchCam/PostCatchSpawnPoint")
@onready var catchFinishedPlaying = false
@onready var f = null

var fish_size_min
var fish_size_max
@onready var size_of_fish = 0

var launch = false

func _input(event):
	if(Input.is_action_just_pressed("right_click") || Input.is_action_just_pressed("left_click")) && catchFinishedPlaying:
		queue_free()
		player.unfreezePlayer()
		playerCam.current = true
		rod.unfreezeCasting()
		print("skip")

#currently instanced in bobber.gd physics process function
func _ready():
	$FishApplause.play()
	
	setFishSize(pickFish())
	#sets camera to fishCam and moves it to appropriate position relative to the 
	#fishes size
	fCam.current = true
	fCam.translate(Vector3(0,0,size_of_fish - 3))
	player.freezePlayer()
	rod.freezeCasting()
	get_node("%FishAnimationPlayer").play("fishWiggle")
	fishTimer.set_wait_time(screen_switch_time)
	fishTimer.start()

# fish follows the path
func _process(delta):
	if(launch):
		pathFollow.progress_ratio += delta  * 0.4

#deletes fish after screen_switch_time seconds
#this is where the post catch scene starts
func _on_fish_timer_timeout():
	catchFinishedPlaying = true
	postCatchCam.current = true
	#postCatchCam.translate(Vector3(0,0,size_of_fish - (size_of_fish * 0.6)))
	#postCatchCam.translate(Vector3(0,0,1))
	print(size_of_fish)
	#change position of f to the olcoation of postCatchCamSpawnPoint
	f.global_position = postCatchCamSpawnPoint.global_position
	f.global_rotation = postCatchCamSpawnPoint.global_rotation
	#f.rotation = Vector3.UP
	#f.set_global_rotation(Vector3.UP)
	#f.rotate_z(90)
	#look_at(hook.global_transform.origin, Vector3.UP)
	#queue_free()
	if(fishID == "Rudd"):
		fishDisplay.rudd()
	if(fishID == "Manta"):
		fishDisplay.manta()
	if(fishID == "Whale"):
		fishDisplay.whale()

func pickFish():
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rng_num = int(rng.randf_range(0, 100))
	print("FISH PICK NUMBER: " , rng_num)
	
	#rudd
	if(rng_num > 0 && rng_num < 70):
		f = rudd.instantiate()
		fishSpawnPoint.add_child(f)
		f.set_meta("name", "Rudd")
		fishID = "Rudd"
		return f
	#manta
	if(rng_num > 10 && rng_num < 90):
		f = manta.instantiate()
		fishSpawnPoint.add_child(f)
		f.set_meta("name", "Manta")
		fishID = "Manta"
		return f
	#whale
	if(rng_num > 90 && rng_num < 100):
		f = whale.instantiate()
		fishSpawnPoint.add_child(f)
		f.set_meta("name", "Whale")
		fishID = "Whale"
		return f

func setFishSize(fish):
	if(fish.get_meta("name") == "Manta"):
		fish_size_min = 5
		fish_size_max = 8
	if(fish.get_meta("name") == "Rudd"):
		fish_size_min = 1.5
		fish_size_max = 2.5
	if(fish.get_meta("name") == "Whale"):
		fish_size_min = 10
		fish_size_max = 20
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rng_size = rng.randf_range(fish_size_min, fish_size_max)
	
	fish.scale.x = rng_size
	fish.scale.y = rng_size
	fish.scale.z = rng_size
	
	size_of_fish = rng_size
	fishSize.text = "[shake]" + str(snapped(rng_size, 0.01)) + " Meters"
	print("FISH SIZE ", rng_size)
