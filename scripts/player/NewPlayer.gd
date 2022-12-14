extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var sprint_speed = 1.0
@onready var neck := $Neck
@onready var camera := $Neck/PlayerCamera
@onready var canMove = true

func _ready():
	pass

func _unhandled_input(event):
	if event is InputEventMouseButton && canMove:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.015)
			camera.rotate_x(-event.relative.y * 0.015)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-55), deg_to_rad(60))
	
	
func _physics_process(delta):
	
	# Handle sprint.
	if Input.is_action_just_pressed("run"):
		sprint_speed = 3
	elif Input.is_action_just_released("run"):
		sprint_speed = 1

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() && canMove:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left","right","up","down")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction && canMove:
		velocity.x = direction.x * SPEED * sprint_speed
		velocity.z = direction.z * SPEED * sprint_speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func freezePlayer():
	canMove = false

func unfreezePlayer():
	canMove = true

