extends Camera2D

# Drag your LittleGuy node into this slot in the Inspector
@export var player: CharacterBody2D 

# Force the math to strictly use your internal 256x256 pixel grid
const ROOM_WIDTH: float = 256.0
const ROOM_HEIGHT: float = 256.0

func _ready() -> void:
	# Keep smooth sliding active
	position_smoothing_enabled = true
	position_smoothing_speed = 10.0 

func _process(_delta: float) -> void:
	if not player:
		return
		
	# 1. Shift the player's position by half a room size to align with a (0,0) centered grid
	var shifted_x: float = player.global_position.x + (ROOM_WIDTH / 2.0)
	var shifted_y: float = player.global_position.y + (ROOM_HEIGHT / 2.0)
	
	# 2. Find the current grid cell coordinate using the shifted position
	var grid_x: float = floor(shifted_x / ROOM_WIDTH)
	var grid_y: float = floor(shifted_y / ROOM_HEIGHT)
	
	# 3. Calculate the exact center point of this grid cell
	var target_position = Vector2(
		grid_x * ROOM_WIDTH,
		grid_y * ROOM_HEIGHT
	)
	
	# 4. Slide smoothly to the center of the active room grid
	global_position = target_position
