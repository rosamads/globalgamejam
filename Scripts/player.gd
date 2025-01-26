extends CharacterBody2D

signal spawn_bubble(position: Vector2, velocity: Vector2)

@onready var sprite = $AnimatedSprite2D
@onready var jump_sfx = $JumpSound
var bubble_ready = false
var animation_playing = 0

const ACCEL = 1000
const FRICTION = 1000
const TOP_SPEED = 700.0
const JUMP_VELOCITY = -500.0
const TURN_AROUND_MULTIPLIER = 4
const yote_time_start = 0.23

const BUBBLE_VEL_OFFSET = 200
const BUBBLE_VEL_SLOW = 900
const BUBBLE_VEL_FAST = 1000

var jump_buff_timer: Timer
var jump_buffered = false
var bubbled = false
var last_dir = 0
var can_yote = false
var yote_timer = 0


func _ready() -> void:
	jump_buff_timer = $JumpBuffTimer

func _physics_process(delta: float) -> void:
	#bubbles
	if Input.is_action_just_pressed("aim_up") and not bubbled and not animation_playing:
		sprite.speed_scale = 1
		sprite.play("attack")
		animation_playing = animation_playing + 1
		if last_dir < 0:
			sprite.flip_h = true
			spawn_bubble.emit(position, velocity + Vector2(-BUBBLE_VEL_SLOW,-BUBBLE_VEL_OFFSET))
		else:
			sprite.flip_h = false
			spawn_bubble.emit(position, velocity + Vector2(BUBBLE_VEL_SLOW,-BUBBLE_VEL_OFFSET))
		bubbled = true
	if Input.is_action_just_pressed("aim_down") and not bubbled and not animation_playing:
		sprite.speed_scale = 1
		sprite.play("attack")
		animation_playing = animation_playing + 1
		if last_dir < 0:
			sprite.flip_h = true
			spawn_bubble.emit(position, velocity + Vector2(-BUBBLE_VEL_SLOW,BUBBLE_VEL_OFFSET))
		else:
			sprite.flip_h = false
			spawn_bubble.emit(position, velocity + Vector2(BUBBLE_VEL_SLOW,BUBBLE_VEL_OFFSET))
		bubbled = true
	if Input.is_action_just_pressed("aim_left") and not bubbled and not animation_playing:
		sprite.speed_scale = 1
		sprite.flip_h = true
		last_dir = -1
		sprite.offset.x = -4
		sprite.play("attack")
		animation_playing = animation_playing + 1
		spawn_bubble.emit(position, velocity + Vector2(-BUBBLE_VEL_FAST,0))
		bubbled = true
	if Input.is_action_just_pressed("aim_right") and not bubbled and not animation_playing:
		sprite.speed_scale = 1
		sprite.flip_h = false
		last_dir = 1
		sprite.offset.x = 0
		sprite.play("attack")
		animation_playing = animation_playing + 1
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
		yote_timer -= delta
		if yote_timer <= 0:
			can_yote = false
		if animation_playing < 1:
			sprite.speed_scale = 1
			sprite.play("fall")
		velocity += get_gravity() * delta
	else:
		can_yote = true
		yote_timer = yote_time_start

	# Buffer jump.
	if Input.is_action_just_pressed("jump"):
		jump_buffered = true
		jump_buff_timer.start()
	
	# Handle jump.
	if Input.is_action_pressed("jump") and can_yote and jump_buffered:
		if animation_playing < 1:
			animation_playing = animation_playing + 1
			sprite.speed_scale = 1
			sprite.play("jump")
		jump_sfx.play()
		jump_buffered = false
		can_yote = false
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		last_dir = direction
		if direction * velocity.x >= 0:
			if is_on_floor():
				velocity.x = move_toward(velocity.x, direction * TOP_SPEED, ACCEL * delta)
			else:
				velocity.x = move_toward(velocity.x, direction * TOP_SPEED, ACCEL * delta)
		else:
			if is_on_floor():
				velocity.x = move_toward(velocity.x, direction * TOP_SPEED, ACCEL * TURN_AROUND_MULTIPLIER * delta)
			else:
				velocity.x = move_toward(velocity.x, direction * TOP_SPEED, ACCEL * TURN_AROUND_MULTIPLIER * delta)

		
		if animation_playing < 1 and is_on_floor():
			if direction < 0:
				sprite.flip_h = true
				sprite.offset.x = -4
			else:
				sprite.flip_h = false
				sprite.offset.x = 0
			sprite.play("run")
			sprite.speed_scale = velocity.x/400
		velocity.x = move_toward(velocity.x, direction * TOP_SPEED, ACCEL * delta)
			
	else:
		if velocity.x == 0 and animation_playing < 1 and is_on_floor():
			sprite.speed_scale = 1
			sprite.play("default")
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		

	move_and_slide()


func _on_jump_buff_timer_timeout() -> void:
	jump_buffered = false


func _on_animated_sprite_2d_animation_finished() -> void:
	animation_playing = 0
