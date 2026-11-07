extends Camera2D

@export var player: CharacterBody2D 

const ROOM_WIDTH: float = 256.0
const ROOM_HEIGHT: float = 256.0

func _ready() -> void:

	position_smoothing_enabled = true
	position_smoothing_speed = 10.0 


func _process(_delta: float) -> void:
	if not player:
		return

	var shifted_x: float = player.global_position.x + (ROOM_WIDTH / 2.0)
	var shifted_y: float = player.global_position.y + (ROOM_HEIGHT / 2.0)

	var grid_x: float = floor(shifted_x / ROOM_WIDTH)
	var grid_y: float = floor(shifted_y / ROOM_HEIGHT)

	var target_position = Vector2(
		grid_x * ROOM_WIDTH,
		grid_y * ROOM_HEIGHT
	)
	
	global_position = target_position
