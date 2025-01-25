extends CharacterBody2D

const air_friction_multiplier = 2.5

func _physics_process(delta: float) -> void:
	velocity = velocity - velocity * air_friction_multiplier * delta
	
	move_and_slide()


func _on_collision_timer_timeout() -> void:
	collision_layer = 0b100
