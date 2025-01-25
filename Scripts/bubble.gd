extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var bubble_delay = $BubbleDelayTimer
var bubble_timeout = false

const air_friction_multiplier = 2.5
func _ready() -> void:
	visible = false
	
func _physics_process(delta: float) -> void:
	velocity = velocity - velocity * air_friction_multiplier * delta
	move_and_slide()


func _on_collision_timer_timeout() -> void:
	collision_layer = 0b100


func _on_animated_sprite_2d_animation_finished() -> void:
	sprite.play("default")


func _on_bubble_delay_timer_timeout() -> void:
	visible = true
	sprite.play("spawn")
	bubble_timeout = true
