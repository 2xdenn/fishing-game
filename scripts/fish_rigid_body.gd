extends RigidBody3D

@onready var rudd = preload("res://fish/rudd/rudd.tscn")
@onready var whale = preload("res://fish/whale/whale.tscn")
@onready var manta = preload("res://fish/manta/manta_ray.tscn")
@onready var pathFollow = get_node("%PathFollow3d")
@onready var fishSpawnPoint = get_node("%FishSpawnPoint")
@onready var fCam = get_node("%FishCam")
@onready var fishTimer = get_node("%FishTimer")
@onready var fishName = get_node("%FishNameDisplay")
@onready var fishSize = get_node("%FishSizeDisplay")
@onready var fishType = get_node("%FishTypeDisplay")
@onready var screen_switch_time = 3.0
@export var fish: Resource
@export var black: Color
@export var red: Color
@export var green: Color

var fish_size_min
var fish_size_max
var size_of_fish = 0

var launch = false

#currently instanced in bobber.gd physics process function
func _ready():
	$FishApplause.play()
	setFishSize(pickFish())
	#sets camera to fishCam and moves it to appropriate position relative to the 
	#fishes size
	fCam.current = true
	fCam.translate(Vector3(0,0,size_of_fish - 3))
	#need to freeze player here
	get_node("%FishAnimationPlayer").play("fishWiggle")
	fishTimer.set_wait_time(screen_switch_time)
	fishTimer.start()

# fish follows the path
func _process(delta):
	if(launch):
		pathFollow.progress_ratio += delta  * 0.4

#deletes fish after screen_switch_time seconds
func _on_fish_timer_timeout():
	queue_free()
	
func pickFish():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rng_num = int(rng.randf_range(0, 100))
	print("FISH PICK NUMBER: " , rng_num)
	if(rng_num > 0 && rng_num < 70):
		var f = rudd.instantiate()
		fishSpawnPoint.add_child(f)
		f.set_meta("name", "Rudd")
		fishType.push_color(green)
		fishName.text = "Rudd"
		fishType.text = "[wave]common"
		fishType.pop()
		return f
	if(rng_num > 10 && rng_num < 90):
		var f = manta.instantiate()
		fishSpawnPoint.add_child(f)
		f.set_meta("name", "Manta")
		fishType.push_color(black)
		fishName.text = "Manta"
		fishType.text = "[wave][shake]uncommon"
		fishType.pop()
		return f
	if(rng_num > 90 && rng_num < 100):
		var f = whale.instantiate()
		fishSpawnPoint.add_child(f)
		f.set_meta("name", "Whale")
		fishType.push_color(red)
		fishName.text = "Whale"
		fishType.text = "[wave][rainbow][shake]rare"
		fishType.pop()
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
