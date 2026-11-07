extends Path2D

var fly_speed: float = 0.0

@onready var path_follow: PathFollow2D = $PathFollow2D
@onready var sprite: AnimatedSprite2D = $PathFollow2D/AnimatedSprite2D
@onready var glow = $PathFollow2D/glow
var pulse_time = 0.0
func _ready() -> void:
	if path_follow:
		path_follow.loop = true
		path_follow.rotates = false
	if sprite:
		sprite.play("flying")
	var random_base_speed = randf_range(25.0, 45.0)
	if randf() > 0.5:
		fly_speed = random_base_speed
	else:
		fly_speed = -random_base_speed
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if path_follow:
		path_follow.progress += fly_speed * delta
	pulse_time += delta * 4.0
	var pulse_modifier = sin(pulse_time) * 0.25
	glow.scale = Vector2(1.0 + pulse_modifier, 1.0 + pulse_modifier)
	
