extends Resource
class_name FishStats

# Used in pickFish for createFish() function

@export var fish_name : String
@export var fish_node : PackedScene
#@export var fish_rarity : String  
#@export var fish_scale_min : float
#@export var fish_scale_max : float

func getName():
	return fish_name
func getNode():
	return fish_node
