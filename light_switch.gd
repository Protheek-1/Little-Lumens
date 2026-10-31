extends Area2D

signal state_changed(is_lit: bool)

@export var partner_switch: Area2D

@export var target_doors: Array[Node2D] = [] 

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var active_light_sources: int = 0

var is_currently_active: bool = false

func _ready() -> void:
	if sprite:
		sprite.play("idle")
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	

func _on_area_entered(area: Area2D) -> void:
	# Instantly opens the door when the player walks into the switch area
	if area.name == "PlayerGlow" or area.is_in_group("light_source") or area.name == "LampGlow":
		active_light_sources += 1
		if active_light_sources >= 1:
			is_currently_active = true
			if sprite:
				sprite.play("lit")
			state_changed.emit(true)
			if partner_switch and partner_switch.is_currently_active:
				open_all_doors()
			

func _on_area_exited(area: Area2D) -> void:
	# Instantly closes the door when the player walks away
	if area.name == "PlayerGlow" or area.is_in_group("light_source") or area.name == "LampGlow":
		active_light_sources -= 1
		if active_light_sources <= 0:
			active_light_sources = 0
			is_currently_active = false
			if sprite:
				sprite.play("idle")
			state_changed.emit(false)	
			close_all_doors()

func open_all_doors() -> void:
	for door in target_doors:
		if door and door.has_method("open"):
			door.open()

func close_all_doors() -> void:
	for door in target_doors:
		if door and door.has_method("close"):
			door.close()
