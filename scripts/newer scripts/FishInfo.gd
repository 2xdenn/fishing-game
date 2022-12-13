extends Control

@onready var fishName = get_node("%NameText")
@onready var fishSize = get_node("%NameText")
@onready var fishRarity = get_node("%NameText")
@onready var pickFish = get_node("/root/UnderwaterTestWorld/Player/Neck/PickFish")

func displayFishInfo():
	fishName.text = str(pickFish.fish_name)
	fishRarity.text = str(pickFish.rarity)
	fishSize.text = str(pickFish.rng_size)
