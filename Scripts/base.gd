extends Node


const cam_move_multiplier = 1.2
const cam_reset_speed = 25
const look_ahead_multiplier = 100

var maincam: Camera2D
var player: CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $Player
	maincam = $MainCam


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.velocity.x != 0:
		#cam x
		var x_dir = 1 if player.velocity.x > 0 else -1
		var look_ahead_x = player.position.x + (x_dir * look_ahead_multiplier)
		maincam.position.x = move_toward(maincam.position.x,
			look_ahead_x, abs(player.velocity.x) * cam_move_multiplier * delta)
	else:
		maincam.position.x = move_toward(maincam.position.x,
			player.position.x, cam_reset_speed * delta)
	
	if player.velocity.y != 0:
		#cam y
		var y_dir = 1 if player.velocity.y > 0 else -1
		var look_ahead_y = player.position.y + (y_dir * look_ahead_multiplier)
		maincam.position.y = move_toward(maincam.position.y,
			look_ahead_y, abs(player.velocity.y) * cam_move_multiplier * delta)
	else:
		maincam.position.y = move_toward(maincam.position.y,
			player.position.y, cam_reset_speed * delta)
