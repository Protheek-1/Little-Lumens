extends Control
@onready var play_prompt: Label = $PlayPrompt
@export var main_path: String = "res://Main.tscn"
var is_starting: bool = false
var flash_timer: float = 0.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if sprite:
		sprite.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_starting:
		return
	flash_timer += delta * 6.0
	if play_prompt:
		play_prompt.visible = sin(flash_timer) > 0.0
	if Input.is_action_just_pressed("ui_accept"):
		start_game()
		
func start_game() -> void:
	is_starting = true
	if play_prompt:
		play_prompt.visible = true
		play_prompt.text = "Launching..."
	var tween = create_tween()
	tween.tween_interval(0.4)
	tween.tween_callback(_change_to_game_scene)
func _change_to_game_scene() -> void:
	get_tree().change_scene_to_file(main_path)
