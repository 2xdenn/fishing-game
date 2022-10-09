extends Node

var fish_data

func _ready():
	var file = File.new()
	file.open("res://data/FishTable.json", File.READ)
	var json_object = JSON.new()
	fish_data = json_object.parse(file.get_as_text())
	file.close()
	#fish_data = file.result
	print(fish_data)
	
