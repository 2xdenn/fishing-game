extends Node

#increasing this increases the floor of the rng number starting at 0
#if you set luck to 10, it would generate a number between 10 and 100
#giving you a better chance at picking a higher number
@export var luck: int

@onready var fish_name : String
@onready var rarity : String
@onready var fish_min : float
@onready var fish_max : float
@onready var fish_id : int

@onready var fishSpawnPoint = get_node("%FishSpawn")

@onready var fishData : Dictionary

@onready var rng_size = 0


func LoadFishData(FilePath):
	
	var DataFile = File.new()
	DataFile.open(FilePath, File.READ)
	var DataJSon = JSON.new()
	DataJSon = DataJSon.parse_string(DataFile.get_as_text())
	DataFile.close()
	return DataJSon

func _ready():
	
	fishData = LoadFishData("res://json/FishTable - Sheet1.json")
	setFish(pickFish())
	createFish()
	
	
	print("Fish Name: " + fish_name)
	print("Fish Rarity: " + rarity)
	print("Fish Min: " + str(fish_min))
	print("Fish Max: " + str(fish_max))
	print("Fish ID: " + str(fish_id))

#creates the fish given the parameters with a node3d and gives it a mesh
func createFish():

	var fish_resource = load("res://fish.tres/" + fish_name + ".tres")
	print(fish_resource.getName())
	#print(fish_resource.getNode())
	#var fishNode = fish_resource.getNode().instantiate()
	fishSpawnPoint.add_child(fish_resource.getNode().instantiate())


#returns a String with a fishes index in it
func pickFish():
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rng_num = int(rng.randf_range(0 + luck, 100))
	print("FISH PICK NUMBER: " , rng_num)
	
	#common
	if(rng_num > 0 && rng_num < 70):
		#creates an array with the index's of all the common fish and selects
		#one of them at random, returning a string with its name
		var commonFish : Array
		for i in fishData.size():
			i += 1
			if(fishData[str(i)]["RarityTag"] == "Common"):
				commonFish += [i]
		#returns a random common fish index
		return commonFish[randi() % commonFish.size()]
	#uncommon
	if(rng_num > 70 && rng_num < 90):
		var uncommonFish : Array
		for i in fishData.size():
			i += 1
			if(fishData[str(i)]["RarityTag"] == "Uncommon"):
				uncommonFish += [i]
		return uncommonFish[randi() % uncommonFish.size()]
	#rare
	if(rng_num > 90 && rng_num < 100):
		var rareFish : Array
		for i in fishData.size():
			i += 1
			if(fishData[str(i)]["RarityTag"] == "Rare"):
				rareFish += [i]
		return rareFish[randi() % rareFish.size()]

func setFish(index : int):
	
	fish_id = index
	fish_name = fishData[str(index)]["FishName"]
	fish_min = fishData[str(index)]["FishScaleMin"]
	fish_max = fishData[str(index)]["FishScaleMax"]
	rarity = fishData[str(index)]["RarityTag"]

#has to set a random fish size between the fishes min size and max size
#has to read in this data from the fish type
func setFishSize(fish):
	
	var fish_size_min = fishData[fish]["FishScaleMin"]
	var fish_size_max = fishData[fish]["FishScaleMax"]
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	rng_size = rng.randf_range(fish_size_min, fish_size_max)
	#fish.scale = rng_size
	
	print(fishData[fish])

#has to return the size of the fish after it has been set in setFishSize 
func getFishSize():
	return rng_size

func getFishRarity():
	return rarity
