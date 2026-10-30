extends Area2D

@export var target_door: Node2D 

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	# Instantly opens the door when the player walks into the switch area
	if body.is_in_group("player"):
		activate_switch()

func _on_body_exited(body: Node) -> void:
	# Instantly closes the door when the player walks away
	if body.is_in_group("player"):
		deactivate_switch()

func activate_switch() -> void:
	if has_node("ColorRect"):
		$ColorRect.color = Color.YELLOW
	if target_door and target_door.has_method("open"):
		target_door.open()

func deactivate_switch() -> void:
	if has_node("ColorRect"):
		$ColorRect.color = Color.DARK_GRAY
	if target_door and target_door.has_method("close"):
		target_door.close()
