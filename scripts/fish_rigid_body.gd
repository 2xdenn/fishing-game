extends RigidBody3D

@onready var pathFollow = get_node("%PathFollow3d")
@onready var fCam = get_node("%FishCam")
@onready var fishTimer = get_node("%FishTimer")
@onready var screen_switch_time = 3.0

var launch = false

#currently instanced in bobber.gd physics process function
func _ready():
	$FishApplause.play()
	fCam.current = true
	#need to freeze player here
	get_node("%FishAnimationPlayer").play("fishWiggle")
	fishTimer.set_wait_time(screen_switch_time)
	fishTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(launch):
		pathFollow.progress_ratio += delta  * 0.4


func _on_fish_timer_timeout():
	queue_free()
