extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var SENSITIVITY=0.005

const BOB_FREQ=2.0
const BOB_AMP=0.1
var t_bob=0.0

@onready var  Pivot=$Pivot
@onready var Camera=$Pivot/Camera3D


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		Pivot.rotate_y(-event.relative.x*SENSITIVITY)
		Camera.rotate_x(-event.relative.y*SENSITIVITY)
		Camera.rotation.x=clamp(Camera.rotation.x,deg_to_rad(-45),deg_to_rad(90))

func _ready() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction = (Pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	t_bob+=delta*velocity.length()*float(is_on_floor())
	Camera.transform.origin=head_bob(t_bob)

	move_and_slide()


func head_bob(t_bob) ->Vector3:
	var pos=Vector3.ZERO
	pos.y=sin(t_bob*BOB_FREQ)*BOB_AMP
	return pos
