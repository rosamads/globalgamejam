extends Node

var maincam: Camera2D
var player: CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $Player
	maincam = $MainCam


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	maincam.position = player.position
