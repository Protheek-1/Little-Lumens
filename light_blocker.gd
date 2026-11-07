extends RigidBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if sprite:
		sprite.play("shining")
	add_to_group("blocks")
	collision_layer = 1
	collision_mask = 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
	
func _physics_process(_delta: float) -> void:

	if linear_velocity.length() < 5.0:
		linear_velocity = Vector2.ZERO
		
func get_lifted(player_node: Node2D) -> void:
	freeze = true
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)
func get_placed() -> void:
	freeze = false
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", false)
