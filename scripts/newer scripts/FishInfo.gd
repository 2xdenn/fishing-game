extends Control

@onready var fishName = get_node("%NameText")
@onready var fishSize = get_node("%SizeText")
@onready var fishRarity = get_node("%RarityText")
@onready var pickFish = get_node("/root/UnderwaterTestWorld/Player/Neck/PickFish")

func _ready():
	fishName.text = " "
	fishRarity.text = " "
	fishSize.text = " "

func displayFishInfo():
	fishName.text = pickFish.fish_name
	fishRarity.text = pickFish.rarity
	fishSize.text = str(snapped(pickFish.rng_size, 0.01)) + " in."
	
func resetText():
	fishName.text = " "
	fishRarity.text = " "
	fishSize.text = " "
