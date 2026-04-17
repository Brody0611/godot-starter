class_name Player
extends CharacterBody2D

@export var world_bounds_top: CollisionShape2D
@export var world_bounds_right: CollisionShape2D
@export var world_bounds_bottom: CollisionShape2D
@export var world_bounds_left: CollisionShape2D

enum PlayerStates {
	IDLE,
	WALKING,
	FALLING,
	JUMPING,
}

var current_state: PlayerStates = PlayerStates.IDLE

const GRAVITY = 1000.0
const FALL_GRAVITY = 1500.0
const FAST_FALL_GRAVITY = 2500.0
const WALL_GRAVITY = .01

const JUMP_VELOCITY = -550.0
const WALL_JUMP_VELOCITY = -650.0
const WALL_JUMP_PUSHBACK = 700.0

const INPUT_BUFFER_PATIENCE = 0.1
const COYOTE_TIME = 0.08

const SPEED = 350
const ACCELERATION = 2500
const FRICTION = 275

var input_buffer : Timer
var coyote_timer : Timer
var coyote_jump_available : bool = true

func _ready() -> void:
	set_camera_limits()
	
	
	input_buffer = Timer.new()
	input_buffer.wait_time = INPUT_BUFFER_PATIENCE
	input_buffer.one_shot = true
	add_child(input_buffer)
	
	coyote_timer = Timer.new()
	coyote_timer.wait_time = COYOTE_TIME
	coyote_timer.one_shot = true
	add_child(coyote_timer)
	coyote_timer.timeout.connect(coyote_timeout)
	
func _physics_process(delta: float) -> void:
	var horisontal_input = Input.get_axis("move_left","move_right")
	var jump_attepted = Input.is_action_just_pressed("jump")
	
	if jump_attepted or input_buffer.time_left > 0:
		if coyote_jump_available:
			velocity.y = JUMP_VELOCITY
			coyote_jump_available = false
		elif is_on_wall() and horisontal_input != 0:
			velocity.y = WALL_JUMP_VELOCITY
			velocity.x = WALL_JUMP_PUSHBACK * -sign(horisontal_input)
		elif jump_attepted:
			input_buffer.start()
		
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 4
		
	if is_on_floor():
		coyote_jump_available = true
		coyote_timer.stop()
		
	else:
		if coyote_jump_available:
			if coyote_timer.is_stopped():
				coyote_timer.start()
		velocity.y += get_the_gravity() * delta
		
	var floor_damping :  float = 1.0 if is_on_floor else 0.2
	var dash_multiplier : float = 2.0 if Input.is_action_pressed("dash") else 1.0
	if horisontal_input:
		velocity.x = move_toward(velocity.x, horisontal_input * SPEED * dash_multiplier, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, (FRICTION * delta) * floor_damping)
	
	#determne current state
	if not is_on_floor():
		current_state = PlayerStates.FALLING if velocity.y >= 0 else PlayerStates.JUMPING
	elif velocity.x != 0:
		current_state = PlayerStates.WALKING
	else:
		current_state = PlayerStates.IDLE
	move_and_slide()

func get_the_gravity(input_dir : float = 0) -> float:
	if Input.is_action_pressed("fast_fall"):
		return FAST_FALL_GRAVITY
	if is_on_wall_only() and velocity.y > 0 and input_dir != 0:
		return WALL_GRAVITY
	return GRAVITY if velocity.y < 0 else FALL_GRAVITY

func coyote_timeout():
	coyote_jump_available = false

func set_camera_limits() -> void:
	var camera := %Camera2D
	
	if world_bounds_top != null:
		camera.limit_top = world_bounds_top.position.y
	
	if world_bounds_right != null:
		camera.limit_right = world_bounds_right.position.x
		
	if world_bounds_bottom != null:
		camera.limit_bottom = world_bounds_bottom.position.y
		
	if world_bounds_left != null:
		camera.limit_left = world_bounds_left.position.x
		
