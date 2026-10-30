extends Area2D

signal state_changed(is_lit: bool)

@export var target_doors: Array[Node2D] = [] 

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_illuminated: bool = false

func _ready() -> void:
	if sprite:
		sprite.play("idle")
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	

func _on_area_entered(area: Area2D) -> void:
	# Instantly opens the door when the player walks into the switch area
	if area.name == "PlayerGlow" or area.is_in_group("light_source"):
		activate_switch()

func _on_area_exited(area: Area2D) -> void:
	# Instantly closes the door when the player walks away
	if area.name == "PlayerGlow" or area.is_in_group("light_source"):
		deactivate_switch()

func activate_switch() -> void:
	if sprite:
		sprite.play("lit")
	state_changed.emit(true)
	for door in target_doors:
		if door and door.has_method("open"):
			door.open()

func deactivate_switch() -> void:
	if sprite:
		sprite.play("idle")
	state_changed.emit(false)
	for door in target_doors:
		if door and door.has_method("close"):
			door.close()
