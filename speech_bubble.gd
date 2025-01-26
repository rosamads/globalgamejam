extends Sprite2D
@onready var timer = $Timer

func _on_area_2d_body_entered(_body: Node2D) -> void:
	visible = true
	timer.start()


func _on_timer_timeout() -> void:
	visible = false
