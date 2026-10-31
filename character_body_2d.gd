extends CharacterBody2D

const SPEED = 120.0
var last_facing = "down"
var pulse_time = 0.0

@onready var sprite = $AnimatedSprite2D
@onready var glow = $glow
@export var push_speed: float = 120
func _ready():
	add_to_group("player")
	
func _physics_process(delta):
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
	var pushed_block: RigidBody2D = null
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is RigidBody2D:
			pushed_block = collider
			var push_direction = -collision.get_normal()
			pushed_block.linear_velocity = push_direction * push_speed
	if pushed_block == null:
		if get_parent():
			for child in get_parent().get_children():
				if child is RigidBody2D:
					child.linear_velocity = Vector2.ZERO
	
	pulse_time += delta * 2.0
	var pulse_modifier = sin(pulse_time) * 0.04
	glow.scale = Vector2(1.0 + pulse_modifier, 1.0 + pulse_modifier)
	
	if direction != Vector2.ZERO:
		sprite.speed_scale = 2.0
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				sprite.play("walk_right")
				last_facing = "right"
			else:
				sprite.play("walk_left")
				last_facing = "left"
		else:
			if direction.y > 0:
				sprite.play("walk_down")
				last_facing = "down"
			else:
				sprite.play("walk_up")
				last_facing = "up"
	else:
		sprite.speed_scale = 0.8
		sprite.play("walk_" + last_facing)
				
	
