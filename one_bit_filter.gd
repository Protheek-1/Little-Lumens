extends ColorRect

func _process(_delta: float) -> void:

	var canvas_transform: Transform2D = get_canvas_transform()
	
	var camera_position: Vector2 = -canvas_transform.origin / canvas_transform.get_scale()
	var screen_size: Vector2 = get_viewport_rect().size / canvas_transform.get_scale()
	
	global_position = camera_position
	size = screen_size
