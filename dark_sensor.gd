extends Area2D

signal state_changed(is_lit: bool)

@export var partner_switch: Area2D

@export var target_doors: Array[Node2D] = [] 

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var active_light_sources: int = 0

var is_currently_active: bool = true

func _ready() -> void:
	if sprite:
		sprite.play("idle")
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	check_initial_state.call_deferred()
	
func check_initial_state() -> void:
	if is_currently_active:
		if partner_switch == null or partner_switch.is_currently_active:
			open_all_doors()
	
func _on_area_entered(area: Area2D) -> void:
	
	if area.name == "DarkZone" or area.is_in_group("dark_zone"):
		active_light_sources -= 20
		if active_light_sources <= 0:
			_force_activate_sensor()
			return
	

	if area.name == "PlayerGlow" or area.is_in_group("light_source") or area.name == "LampGlow":
		active_light_sources += 1
		if active_light_sources >= 1:
			is_currently_active = false
			if sprite:
				sprite.play("lit")
			state_changed.emit(false)
			close_all_doors()
			

func _on_area_exited(area: Area2D) -> void:
	
	if area.name == "DarkZone" or area.is_in_group("dark_zone"):
		active_light_sources += 20
		if active_light_sources >= 1:
			is_currently_active = false
			if sprite:
				sprite.play("lit")
			state_changed.emit(false)
			close_all_doors()
			return
		else:
			_force_activate_sensor()
			return

	if area.name == "PlayerGlow" or area.is_in_group("light_source") or area.name == "LampGlow":
		active_light_sources -= 1
		if active_light_sources <= -10:
			return
		if active_light_sources <= 0:
			_force_activate_sensor()
		
			 

func _force_activate_sensor() -> void:
	if active_light_sources <= 0:
			is_currently_active = true
			if sprite:
				sprite.play("idle")
			state_changed.emit(true)
			if partner_switch == null:
				open_all_doors()
			else:
				var partner_is_actually_on = false
				if "active_light_sources" in partner_switch:
					if partner_switch.has_method("check_intial_state"):
						partner_is_actually_on = (partner_switch.active_light_sources == 0)
					else:
						partner_is_actually_on = (partner_switch.active_light_sources >= 1)
					partner_is_actually_on = partner_switch.is_currently_active
				else:
					partner_is_actually_on = partner_switch.is_currently_active
				if partner_is_actually_on:
					open_all_doors()

func open_all_doors() -> void:
	for door in target_doors:
		if door and door.has_method("open"):
			door.open()

func close_all_doors() -> void:
	for door in target_doors:
		if door and door.has_method("close"):
			door.close()
