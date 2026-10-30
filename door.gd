extends StaticBody2D

@onready var rect: ColorRect = $ColorRect
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	close()

func open() -> void:
	collision_shape.set_deferred("disabled", true)
	# Drop the opacity down to 30% so it looks faded out/open
	rect.color.a = 0.3

func close() -> void:
	collision_shape.set_deferred("disabled", false)
	# Bring opacity back to 100% so it looks solid/closed
	rect.color.a = 1.0
