extends Node


const cam_move_multiplier = 1.2
const cam_reset_speed = 25
const look_ahead_multiplier = 100

var maincam: Camera2D
var player: CharacterBody2D
var entities: Node
var bubble_tscn = preload("res://bubble.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $Player
	maincam = $MainCam
	entities = $Entites
	
	player.spawn_bubble.connect(_spawn_bubble)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		$MainCam/Menu.visible = !$MainCam/Menu.visible
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
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

func _spawn_bubble(position, velocity):
	var instance = bubble_tscn.instantiate()
	instance.position = position
	instance.velocity = velocity
	entities.add_child(instance)
