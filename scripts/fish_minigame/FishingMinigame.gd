extends Node2D

var hookVelocity = 0;
var hookAcceleration = .1;
var hookDeceleration = .2
var maxVelocity = 6.0;
var bounce = .6


var fishBite = false

var fishable = true
@onready var fish = preload("res://scenes/MinigameFish.tscn")
@onready var rod = get_node("/root/UnderwaterTestWorld/Player/Neck/FishingRod")

func _process(delta):
	
	if(fishBite == true):
		#minimum distance, maximum distance, move speed, time interval time
		add_fish(40, 290, 6, 2)
		fishBite = false
		fishable = false
	
	if ($Clicker.button_pressed == true):
		if hookVelocity > -maxVelocity:
			hookVelocity -= hookAcceleration
	else:
		if hookVelocity < maxVelocity:
			hookVelocity += hookDeceleration
			
	if (Input.is_action_just_pressed("left_click")):
		hookVelocity -= .5
		
	var target = $Hook.position.y + hookVelocity
	if (target >= 214):
		hookVelocity *= -bounce
	elif (target <= 50):
		hookVelocity = 0
		$Hook.position.y = 50
	else:
		$Hook.position.y = target
		
	# Adjust Value
	if (fishable == false):
		if (len($Hook/Area2D.get_overlapping_areas()) > 0):
			$Progress.value += 125 * delta
			if ($Progress.value >= 999):
				caught_fish()
		else:
			$Progress.value -= 100 * delta
			if ($Progress.value <= 0):
				lost_fish()
		
func caught_fish():
	get_node("MinigameFish").destroy()
	$Message.text = "Caught one!"
	$MessageTimer.set_wait_time(3);
	$MessageTimer.start()
	$Progress.value = 0
	fishable = true
	
	queue_free()
	rod.MinigameWon = true
	
func lost_fish():
	get_node("MinigameFish").destroy()
	$Message.text = "Next time!"
	$MessageTimer.set_wait_time(3);
	$MessageTimer.start()
	$Progress.value = 0
	fishable = true
	
	queue_free()
	rod.MinigameWon = false
	
func add_fish(min_d, max_d, move_speed, move_time):
	var f = fish.instantiate()
	f.position = Vector2($Hook.position.x, $Hook.position.y)
	
	f.min_distance = min_d
	f.max_distance = max_d
	f.movement_speed = move_speed
	f.movement_time = move_time
	
	add_child(f)
	$Progress.value = 200
	fishable = false

func reset_settings():
	hookAcceleration = .1;
	hookDeceleration = .2
	maxVelocity = 6.0;
	bounce = .6

func _on_Clicker_button_down():
	hookVelocity -= .5

func _on_message_timer_timeout():
	$Message.text = ""
