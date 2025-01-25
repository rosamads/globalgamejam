extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
const ACCEL = 1000
const FRICTION = 800
const TOP_SPEED = 1000.0
const JUMP_VELOCITY = -500.0

var jump_buff_timer: Timer
var jump_buffered = false


func _ready() -> void:
	jump_buff_timer = $JumpBuffTimer

func _physics_process(delta: float) -> void:
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
		if direction < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		sprite.play("run")
		velocity.x = move_toward(velocity.x, direction * TOP_SPEED, ACCEL * delta)
		sprite.speed_scale = velocity.x/400
	else:
		if velocity.x == 0:
			sprite.speed_scale = 1
			sprite.play("default")
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	move_and_slide()


func _on_jump_buff_timer_timeout() -> void:
	jump_buffered = false
