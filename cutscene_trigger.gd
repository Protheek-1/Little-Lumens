extends Area2D
@export var player: CharacterBody2D
@export var ending_label: Label
var cutscene_started: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	if ending_label:
		ending_label.visible = false
func _on_body_entered(body: Node2D) -> void:
	if body == player and not cutscene_started:
		cutscene_started = true
		start_corridor_cutscene()
func start_corridor_cutscene() -> void:
	if "is_in_cuutscene" in player:
		player.is_in_cutscene = true
	player.velocity = Vector2.ZERO
	var final_room_centre = Vector2(1044.0, -500.0)
	var cinematic_spot = final_room_centre + Vector2(-20.0, 0.0)
	var tween = create_tween()
	if player.has_node("AnimatedSprite2D"):
		player.get_node("AnimatedSprite2D").play("walk_up")
	tween.tween_property(player, "global_position", cinematic_spot, 3.0)\
		.set_trans(Tween.TRANS_LINEAR)\
		.set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(_on_player_arrived)
	
func _on_player_arrived() -> void:
	if "last_facing" in player:
		player.last_facing = "down"
	if player.has_node("AnimatedSprite2D"):
		player.get_node("AnimatedSprite2D").play("walk_down")
	if ending_label:
		ending_label.visible = true
		ending_label.modulate.a = 0.0
		var text_tween = create_tween()
		text_tween.tween_property(ending_label, "modulate:a", 1.0, 1.2)
		text_tween.tween_interval(4.0)
	
	
	
