extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var neck := $Neck
@onready var camera := $Neck/Camera
@onready var chest_ray = $Neck/Chest
@onready var head_ray = $Neck/HeadRays
@onready var canMove = true
@onready var viewCam = get_node("%ViewCam")

func _unhandled_input(event):
	if event is InputEventMouseButton && canMove:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))
	
	
func _physics_process(delta):
	
	if Input.is_action_just_pressed("camera"):
		viewCam.current = true

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() && canMove:
		velocity.y = JUMP_VELOCITY

	# Handle climbing
	if Input.is_action_just_pressed("jump") and can_climb() && canMove:
		grab_ledge()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left","right","up","down")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction && canMove:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func freezePlayer():
	canMove = false

func unfreezePlayer():
	canMove = true

func can_climb():
	
	if !chest_ray.is_colliding():
		return false
	for ray in head_ray.get_children():
		if ray.is_colliding():
			return false
	return true

func grab_ledge():
	velocity = Vector3.ZERO
	#disable swimming
	climb_ledge()

func climb_ledge():
	var cam_input_frozen = true
	print("climb")
	var tween = create_tween()
	var vertical_movement = global_transform.origin + Vector3(0,1.85,0)
	var forward_movement = global_transform.origin + (-neck.global_transform.basis.z * 1.4) + Vector3(0,1.85,0)
	print(vertical_movement)
	print(forward_movement)
	#.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self,"position",vertical_movement,0.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self,"position",forward_movement,0.5).set_trans(Tween.TRANS_SINE)
	

