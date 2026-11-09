extends Sprite2D
@onready var glow = $glow
var pulse_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pulse_time += delta * 1.0
	var pulse_modifier = sin(pulse_time) * 0.02
	glow.scale = Vector2(1.0 + pulse_modifier, 1.0 + pulse_modifier)
