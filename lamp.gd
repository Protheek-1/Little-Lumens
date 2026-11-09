extends RigidBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var glow = $glow
var pulse_time = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if sprite:
		sprite.play("light")
	add_to_group("blocks")
# Called every frame. 'delta' is the elapsed time since the previous frame.
	
func _physics_process(delta: float) -> void:
	if linear_velocity.length() < 5.0:
		linear_velocity = Vector2.ZERO
	pulse_time += delta * 1.0
	var pulse_modifier = sin(pulse_time) * 0.02
	glow.scale = Vector2(1.0 + pulse_modifier, 1.0 + pulse_modifier)
		
func get_lifted(_player_node: Node2D) -> void:
	freeze = true
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)
	if has_node("PickSound"):
		$PickSound.play()
func get_placed() -> void:
	freeze = false
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", false)
	if has_node("DropSound"):
		$DropSound.play()
