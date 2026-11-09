extends Area2D

signal state_changed(is_lit: bool)

@export var partner_switch: Area2D

@export var target_doors: Array[Node2D] = [] 

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var active_light_sources: int = 0
var active_dark_zones: int = 0
var was_previously_active: bool = false
@export var is_dark_sensor: bool = false
var is_currently_active: bool = false

func _ready() -> void:

	if is_dark_sensor:
		is_currently_active = true
		if sprite: sprite.play("idle") # dark sensor idle = active
	else:
		is_currently_active = false
		if sprite: sprite.play("idle") # light sensor idle = inactive
		
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	

	check_initial_state.call_deferred()

func check_initial_state() -> void:
	if is_currently_active:

		if partner_switch == null:
			open_all_doors()
		elif partner_switch and partner_switch.is_currently_active:
			open_all_doors()

func _on_area_entered(area: Area2D) -> void:
	
	if area.name == "DarkZone" or area.is_in_group("dark_zone"):
		active_light_sources -= 20
		active_dark_zones += 1
		if active_light_sources < 1 and not is_dark_sensor:
			is_currently_active = false
			if sprite: sprite.play("idle")
			state_changed.emit(false)
			close_all_doors()
		check_and_play_audio()
		return
	
	if area.name == "PlayerGlow" or area.is_in_group("light_source") or area.name == "LampGlow":
		active_light_sources += 1
		if active_light_sources >= 1:
			if is_dark_sensor:

				is_currently_active = false
				if sprite: sprite.play("lit")
				state_changed.emit(false)
				close_all_doors() 
			else:
	
				is_currently_active = true
				if sprite: sprite.play("lit")
				state_changed.emit(true)
				
				if partner_switch == null or partner_switch.is_currently_active:
					open_all_doors()
		check_and_play_audio()

func _on_area_exited(area: Area2D) -> void:
	
	if area.name == "DarkZone" or area.is_in_group("dark_zone"):
		active_light_sources += 20
		active_dark_zones -= 1
		if active_light_sources >= 1 and not is_dark_sensor:
			is_currently_active = true
			if sprite: sprite.play("lit")
			state_changed.emit(true)
			if partner_switch == null or partner_switch.is_currently_active:
				open_all_doors()
		return
	
	if area.name == "PlayerGlow" or area.is_in_group("light_source") or area.name == "LampGlow":
		active_light_sources -= 1
		
		if active_dark_zones > 0:
			return
		
		if active_light_sources <= 0:
			active_light_sources = 0
			
			if is_dark_sensor:
		
				is_currently_active = true
				if sprite: sprite.play("idle")
				state_changed.emit(true)
				
				if partner_switch == null or partner_switch.is_currently_active:
					open_all_doors()
			else:
			
				is_currently_active = false
				if sprite: sprite.play("idle")
				state_changed.emit(false)
				close_all_doors()
	check_and_play_audio()

func open_all_doors() -> void:
	for door in target_doors:
		if door and door.has_method("open"):
			door.open()

func close_all_doors() -> void:
	for door in target_doors:
		if door and door.has_method("close"):
			door.close()

func check_and_play_audio() -> void:
	if is_currently_active and not was_previously_active:
		if has_node("ActivateSound"):
			$ActivateSound.play()
	was_previously_active = is_currently_active
