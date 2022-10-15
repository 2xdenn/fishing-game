extends Control

@onready var fishName = get_node("%FishNameDisplay")
@onready var fishType = get_node("%FishTypeDisplay")

func _ready():
	fishName.hide()
	fishType.hide()

func rudd():
	fishName.text = "Rudd"
	fishType.text = "[wave]common"
	fishName.show()
	fishType.show()
func manta():
	fishName.text = "Manta"
	fishType.text = "[wave][shake][color=green]uncommon"
	fishName.show()
	fishType.show()
func whale():
	fishName.text = "Whale"
	fishType.text = "[wave][rainbow][shake]rare"
	fishName.show()
	fishType.show()

