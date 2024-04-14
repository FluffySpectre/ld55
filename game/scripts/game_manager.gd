extends Node3D

@export var player_car: CarController

# @onready var track_generator: TrackGenerator = $TrackGenerator

var start_position: Vector3 = Vector3.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player_car && start_position == Vector3.ZERO:
		start_position = player_car.global_position
	
	if Input.is_action_just_pressed("ui_cancel"):
		reset_player()

func reset_player():
	# TODO: Get the last track the player was driving on
	# and place the car there
	
	player_car.global_position = start_position
	player_car.global_rotation_degrees = Vector3.ZERO
	player_car.linear_velocity = Vector3.ZERO
	player_car.angular_velocity = Vector3.ZERO
