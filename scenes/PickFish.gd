extends Node

#increasing this increases the floor of the rng number starting at 0
#if you set luck to 10, it would generate a number between 10 and 100
#giving you a better chance at picking a higher number
@export var luck: int

@onready var fish_min : float
@onready var fish_max : float
@onready var rarity : int

@onready var rng_size = 0

var list = ["Rudd",1,"egg",3,"dog"]


func _ready():
	
	var arraySize = list.size()
	
	

#needs to return a String with the fishes name after it is called
#has to pick a rarity and then a fish in that rarity class
func pickFish():
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rng_num = int(rng.randf_range(0 + luck, 100))
	#print("FISH PICK NUMBER: " , rng_num)
	
	#common
	if(rng_num > 0 && rng_num < 70):
		#has to read through array of fish names with the common rarity and
		#select one at random
		pass
	#uncommon
	if(rng_num > 70 && rng_num < 90):
		#has to read through array of fish names with the uncommon rarity and
		#select one at random
		pass
	#rare
	if(rng_num > 90 && rng_num < 100):
		#has to read through array of fish names with the uncommon rarity and
		#select one at random
		pass
	
	return "rudd"


#has to set a random fish size between the fishes min size and max size
#has to read in this data from the fish type
func setFishSize(fish, fish_size_min, fish_size_max):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	rng_size = rng.randf_range(fish_size_min, fish_size_max)
	fish.scale = rng_size

#has to return the size of the fish after it has been set in setFishSize 
func getFishSize():
	return rng_size

func getFishRarity():
	return 0
