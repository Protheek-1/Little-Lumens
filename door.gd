extends StaticBody2D

const SMOKE_PUFF_SCENE = preload("res://smoke_puff.tscn")

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	close()

func open() -> void:
	if sprite and sprite.animation != "open":
		sprite.play("open")
		spawn_smoke()
	if collision:
		collision.set_deferred("disabled", true)

func close() -> void:
	if sprite and sprite.animation != "closed":
		sprite.play("closed")
		spawn_smoke()
	if collision:
		collision.set_deferred("disabled", false)
func spawn_smoke() -> void:
	var smoke = SMOKE_PUFF_SCENE.instantiate() as GPUParticles2D
	smoke.global_position = global_position + Vector2(9, 8)
	get_parent().add_child.call_deferred(smoke)
