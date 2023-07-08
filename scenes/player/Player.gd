extends CharacterBody3D


const ACCEL = 5.0
const MAX_VEL_INIT = 3.0
var MAX_VEL = MAX_VEL_INIT
const JUMP_VELOCITY = 9.0

var jump_charging : bool
var charge_time_s : float
var charge_timer : int

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_charging = true
		charge_timer = Time.get_ticks_msec()
		MAX_VEL = MAX_VEL_INIT / 3.0
	
	if Input.is_action_just_released("jump"):
		if jump_charging and is_on_floor():
			var charge_time = (Time.get_ticks_msec() - charge_timer) * 1e-3
			print("Jump charged for ", charge_time, "s")
			# Linear impulse vs. time
			velocity.y = remap(charge_time, 0.2, 1.5, 1, JUMP_VELOCITY)
		jump_charging = false
		MAX_VEL = MAX_VEL_INIT

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor() and direction:
		velocity.x += direction.x * ACCEL * delta
		velocity.z += direction.z * ACCEL * delta
	elif is_on_floor():
		if abs(velocity.x) > 0:
			velocity.x -= sign(velocity.x) * ACCEL * delta * int(abs(velocity.x) > 0.1)
		if abs(velocity.z) > 0:
			velocity.z -= sign(velocity.z) * ACCEL * delta * int(abs(velocity.z) > 0.1)
	
	if is_on_floor() and direction and velocity.length() > MAX_VEL:
		velocity -= velocity.normalized() * (velocity.length() - MAX_VEL) * 0.3 

	move_and_slide()
