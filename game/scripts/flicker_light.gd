extends Light3D

@export var min_intensity: float = 2
@export var max_intensity: float = 16
@export var min_flicker_speed: float = 0.05
@export var max_flicker_speed: float = 0.2
@export var flicker_chance = 0.2

var timer = 0.0
var do_flicker = false

func _ready():
	timer = randf_range(min_flicker_speed, max_flicker_speed)
	do_flicker = randf() < flicker_chance

func _process(delta):
	if !do_flicker:
		return
	
	timer -= delta
	if timer <= 0.0:
		light_energy = randf_range(min_intensity, max_intensity)
		timer = randf_range(min_flicker_speed, max_flicker_speed)
