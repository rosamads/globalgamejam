extends Node

const cam_move_multiplier = 1.2
const cam_reset_speed = 25
const look_ahead_multiplier = 100
const too_far_multiplier = 1000

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
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$Player/Area2D2.connect("area_entered", _win)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		$MainCam/Menu.visible = !$MainCam/Menu.visible
		$MainCam/Menu/MenuSelectSound.play()
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("bubble"):
		$MainCam/MyGame.visible = !$MainCam/MyGame.visible
		$MainCam/Menu/MenuSelectSound.play()
	
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
			look_ahead_y + 50, abs(player.velocity.y) * cam_move_multiplier * delta)
	else:
		maincam.position.y = move_toward(maincam.position.y,
			player.position.y + 50, cam_reset_speed * delta)
			
	if player.position.distance_to(maincam.position) > 350:
		maincam.position = maincam.position.move_toward(
			player.position, cam_reset_speed * delta * too_far_multiplier)

func _spawn_bubble(position, velocity):
	var instance = bubble_tscn.instantiate()
	instance.position = position
	instance.velocity = velocity
	entities.add_child(instance)
	
func _win(_body):
	call_deferred("_win2")
	$MainCam/WinText.visible = true

func _win2():
	$Player.process_mode = Node.PROCESS_MODE_DISABLED
