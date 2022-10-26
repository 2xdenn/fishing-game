extends Node3D

signal chargeBar(boolean)
signal showBar(boolean)
var canCast = true

func _input(event):
	
	#pull fishing rod back
	if Input.is_action_just_pressed("left_click") && canCast:
		
		emit_signal("chargeBar", true)
		emit_signal("showBar", true)
		
	#release fishing rod
	if event.is_action_released("left_click") && canCast:
		
		emit_signal("chargeBar", false)
		emit_signal("showBar", true)
		
func freezeCasting():
	canCast = false

func unfreezeCasting():
	canCast = true
