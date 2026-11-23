extends CharacterBody3D
class_name Jumper

const SPEED = 5.0
const JUMP_VELOCITY = 4.5


@onready var wall_sensor: Area3D = $WallSensor
var can_wall_jump: bool = false

func _ready() -> void:
	wall_sensor.body_entered.connect(on_wall_entered)
	wall_sensor.body_exited.connect(on_wall_exited)

func on_wall_exited(body):
	if body is StaticBody3D:
		can_wall_jump = false

func on_wall_entered(body):
	if body is CharacterBody3D:
		print("Detected a character body. Ignoring.")
	
	if body is StaticBody3D:
		can_wall_jump = true
		print("hit a wall. engage wall jumping system.")



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Floor Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Wall Jump
	if Input.is_action_just_pressed("jump") and can_wall_jump:
		velocity.y = JUMP_VELOCITY
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
