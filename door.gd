extends StaticBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	close()

func open() -> void:
	if sprite:
		sprite.play("open")
	if collision:
		collision.set_deferred("disabled", true)

func close() -> void:
	if sprite:
		sprite.play("closed")
	if collision:
		collision.set_deferred("disabled", false)
