extends Area2D

signal state_changed(is_lit: bool)

# OPTIONAL: Leave this blank [Empty] in the Inspector if it is a standalone switch!
@export var partner_switch: Area2D

@export var target_doors: Array[Node2D] = [] 

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var active_light_sources: int = 0

# CHANGE THIS CONFIG TO MATCH SENSOR TYPE:
# For a Normal Light Sensor: Set to false (starts off in the dark)
# For a Dark Sensor: Set to true (starts active on boot-up in the dark)
@export var is_dark_sensor: bool = false
var is_currently_active: bool = false

func _ready() -> void:
	# Synchronise initial state rules based on type
	if is_dark_sensor:
		is_currently_active = true
		if sprite: sprite.play("idle") # Dark sensor idle = active
	else:
		is_currently_active = false
		if sprite: sprite.play("idle") # Light sensor idle = inactive
		
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
	# Run a deferred boot-up check to set initial door positions
	check_initial_state.call_deferred()

func check_initial_state() -> void:
	if is_currently_active:
		# If there's no partner, automatically open the doors!
		if partner_switch == null:
			open_all_doors()
		elif partner_switch and partner_switch.is_currently_active:
			open_all_doors()

func _on_area_entered(area: Area2D) -> void:
	if area.name == "PlayerGlow" or area.is_in_group("light_source") or area.name == "LampGlow":
		active_light_sources += 1
		if active_light_sources >= 1:
			if is_dark_sensor:
				# LIGHT HITS DARK SENSOR -> Deactivates
				is_currently_active = false
				if sprite: sprite.play("lit")
				state_changed.emit(false)
				close_all_doors() # Instantly close if either breaks
			else:
				# LIGHT HITS LIGHT SENSOR -> Activates
				is_currently_active = true
				if sprite: sprite.play("lit")
				state_changed.emit(true)
				
				# Check if standalone OR partner is also happy
				if partner_switch == null or partner_switch.is_currently_active:
					open_all_doors()

func _on_area_exited(area: Area2D) -> void:
	if area.name == "PlayerGlow" or area.is_in_group("light_source") or area.name == "LampGlow":
		active_light_sources -= 1
		if active_light_sources <= 0:
			active_light_sources = 0
			
			if is_dark_sensor:
				# LIGHT LEAVES DARK SENSOR -> Reactivates
				is_currently_active = true
				if sprite: sprite.play("idle")
				state_changed.emit(true)
				
				if partner_switch == null or partner_switch.is_currently_active:
					open_all_doors()
			else:
				# LIGHT LEAVES LIGHT SENSOR -> Deactivates
				is_currently_active = false
				if sprite: sprite.play("idle")
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
