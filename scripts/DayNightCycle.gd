extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("%DayNightAnimation").play("day_night_animation")

