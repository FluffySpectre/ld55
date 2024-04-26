extends CanvasItem

@export var min_intensity: float = 0.1
@export var max_intensity: float = 0.8
@export var min_flicker_speed: float = 0.075
@export var max_flicker_speed: float = 0.25

var timer = 0.0

func _ready():
	timer = randf_range(min_flicker_speed, max_flicker_speed)

func _process(delta):
	timer -= delta
	if timer <= 0.0:
		modulate.a = randf_range(min_intensity, max_intensity)
		timer = randf_range(min_flicker_speed, max_flicker_speed)
