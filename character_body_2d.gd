extends CharacterBody2D

# Keep your fast rocket speed!
const SPEED = 100.0


	
func _physics_process(_delta):
	var input_vector = Vector2.ZERO
	if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
		input_vector.x += 1
	if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A):
		input_vector.x -= 1
	if Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_S):
		input_vector.y += 1
	if Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W):
		input_vector.y -= 1
	# Set your velocity and move smoothly through walls 
	var direction = input_vector.normalized()
	velocity = direction * SPEED
	move_and_slide()
	
	var flashlight = $PointLight2D
	
	if flashlight:
		var angle_to_mouse = get_local_mouse_position().angle()
		flashlight.rotation = angle_to_mouse
