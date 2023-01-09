extends Node2D

var movement_speed = 6
var movement_time = 3

var min_distance = 100
var max_distance = 290

@onready var min_position = 100
@onready var max_position = 290

@onready var target = 1

@onready var tween = create_tween()


func _ready():
	plan_move()
	
func plan_move():

	var rng = RandomNumberGenerator.new()
	target = rng.randf_range(min_position, max_position)

	
	while (abs(self.position.y - target) < min_distance or abs(self.position.y - target) > max_distance):
		rng.randomize()
		target = rng.randf_range(min_position, max_position)
		
	move(Vector2(self.position.x, target))

	
func move(target):
	tween.tween_property(self, "position", target, movement_speed).set_trans(tween.TRANS_QUINT)
	tween.play()
	
	$MoveTimer.set_wait_time(movement_time)
	$MoveTimer.start()

func destroy():
	get_parent().remove_child(self)
	queue_free()

func _on_move_timer_timeout():
	tween.stop()
	plan_move()
	print(target)
