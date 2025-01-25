extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var bubble_delay = $BubbleDelayTimer
@onready var pop_timer = $PopTimer
var bubble_timeout = false

const air_friction_multiplier = 2.5
func _ready() -> void:
	visible = false
	
func _physics_process(delta: float) -> void:
	velocity = velocity - velocity * air_friction_multiplier * delta
	move_and_slide()

func pop_self():
	var pop_animation = "pop_" + str(randi_range(1, 3))
	sprite.play(pop_animation)
	pop_timer.start()
	

func _on_collision_timer_timeout() -> void:
	collision_layer = 0b100


func _on_animated_sprite_2d_animation_finished() -> void:
	sprite.play("default")


func _on_despawn_timer_timeout() -> void:
	pop_self()

func _on_bubble_delay_timer_timeout() -> void:
	visible = true
	sprite.play("spawn")
	bubble_timeout = true


func _on_pop_timer_timeout() -> void:
	get_parent().remove_child(self)
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	sprite.play("pressed")


func _on_area_2d_body_exited(body: Node2D) -> void:
	sprite.play("default")
