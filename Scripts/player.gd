extends CharacterBody2D

signal spawn_bubble(position: Vector2, velocity: Vector2)

const ACCEL = 1000
const FRICTION = 1000
const TOP_SPEED = 700.0
const JUMP_VELOCITY = -500.0
const TURN_AROUND_MULTIPLIER = 4

const BUBBLE_VEL_OFFSET = 200
const BUBBLE_VEL_SLOW = 900
const BUBBLE_VEL_FAST = 1000

var jump_buff_timer: Timer
var jump_buffered = false
var bubbled = false


func _ready() -> void:
	jump_buff_timer = $JumpBuffTimer

func _physics_process(delta: float) -> void:
	#bubbles
	if Input.is_action_just_pressed("aim_up") and not bubbled:
		spawn_bubble.emit(position, velocity + Vector2(BUBBLE_VEL_SLOW,-BUBBLE_VEL_OFFSET))
		bubbled = true
	if Input.is_action_just_pressed("aim_down") and not bubbled:
		spawn_bubble.emit(position, velocity + Vector2(BUBBLE_VEL_SLOW,BUBBLE_VEL_OFFSET))
		bubbled = true
	if Input.is_action_just_pressed("aim_left") and not bubbled:
		spawn_bubble.emit(position, velocity + Vector2(-BUBBLE_VEL_FAST,0))
		bubbled = true
	if Input.is_action_just_pressed("aim_right") and not bubbled:
		spawn_bubble.emit(position, velocity + Vector2(BUBBLE_VEL_FAST,0))
		bubbled = true
	if not (Input.is_action_pressed("aim_up") or
		Input.is_action_pressed("aim_down") or
		Input.is_action_pressed("aim_left") or
		Input.is_action_pressed("aim_right")):
		bubbled = false
	#if Input.is_action_just_pressed("bubble"):
	#	var bx := Input.get_axis("aim_left", "aim_right")
	#	var by := Input.get_axis("aim_up", "aim_down")
	#	spawn_bubble.emit(position, velocity + Vector2(bx,by).normalized() * TOP_SPEED)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Buffer jump.
	if Input.is_action_just_pressed("jump"):
		jump_buffered = true
		jump_buff_timer.start()
	
	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor() and jump_buffered:
		jump_buffered = false
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		if direction * velocity.x >= 0:
			velocity.x = move_toward(velocity.x, direction * TOP_SPEED, ACCEL * delta)
		else:
			velocity.x = move_toward(velocity.x, direction * TOP_SPEED, ACCEL * TURN_AROUND_MULTIPLIER * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	move_and_slide()


func _on_jump_buff_timer_timeout() -> void:
	jump_buffered = false
