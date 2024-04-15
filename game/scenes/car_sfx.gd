extends Node3D

@export var engine_sfx: AudioStream
@export var brake_sfx: AudioStream

@onready var car_controller: CarController = get_parent()
@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

var min_pitch = 0.5
var max_pitch = 1.5

func _ready():
	audio_player.stream = engine_sfx
	audio_player.play()

func _process(delta):
	if car_controller.brake > 0:
		if audio_player.stream != brake_sfx:
			audio_player.stream = brake_sfx
			audio_player.play()
	else:
		if audio_player.stream != engine_sfx:
			audio_player.stream = engine_sfx
		
		var velocity = car_controller.linear_velocity.length()
		audio_player.pitch_scale = remap(velocity, 0.0, car_controller.max_speed, min_pitch, max_pitch)
	
		if !audio_player.playing:
			audio_player.play()
		
