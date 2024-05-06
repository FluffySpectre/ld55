class_name GameManager extends Node

@export var player_car: CarController
@export var cam_controller: CameraController
@export var track_generator: TrackGenerator
@export var intro_animation_player: AnimationPlayer
@export var world_environment: WorldEnvironment

signal pickup_picked_up(type)
signal score_changed(new_score: int)

static var instance: GameManager

var start_position: Vector3 = Vector3.ZERO
var total_spawned_tracks = 0
var distance_interval = 150.0
var score_per_interval = 5.0
var last_position = Vector3.ZERO
var distance_in_target_direction_interval = 0.0

enum GameState {
	INTRO,
	MENU,
	IN_GAME
}
var game_state: GameState = GameState.INTRO

func _ready():
	instance = self
	
	Globals.player_car = player_car
	last_position = player_car.global_position

	track_generator.on_track_spawned.connect(on_track_spawned)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player_car && start_position == Vector3.ZERO:
		start_position = player_car.global_position
		last_position = player_car.global_position
	
	if game_state == GameState.IN_GAME:
		if Input.is_action_just_pressed("ui_cancel"):
			reset_player()
		
		update_score()
	
	if game_state == GameState.MENU:
		if Input.is_action_pressed("accelerate") || Input.is_action_pressed("brake") || Input.is_action_pressed("steer_left") || Input.is_action_pressed("steer_left"):
			start_game()

func start_game():
	game_state = GameState.IN_GAME
	intro_animation_player.play("game_in")
	
	print("Game started")
	
	Globals.spawn_enemies = true
	
	last_position = player_car.global_position

func update_score():
	var current_position = player_car.global_position
	var movement_vector = current_position - last_position
	var target_direction = Vector3(0, 0, 1)
	var distance_this_frame = movement_vector.dot(target_direction)
	
	if distance_this_frame > 0:
		distance_in_target_direction_interval += distance_this_frame
		Globals.distance_in_target_direction += distance_this_frame
	
	if distance_in_target_direction_interval >= distance_interval:
		Globals.score += score_per_interval
		distance_in_target_direction_interval -= distance_interval
		score_changed.emit(Globals.score)
		
	last_position = current_position

func reset_player():
	# TODO: Get the last track the player was driving on
	# and place the car there
	
	# Reload the entire scene for now
	get_tree().reload_current_scene()
	return
	
	track_generator.reset_track()
	var first_track_part = track_generator.loaded_street_parts[0]
	
	player_car.global_position = first_track_part.global_position + Vector3(0, 0, 10.0)
	player_car.global_rotation_degrees = Vector3.ZERO
	player_car.linear_velocity = Vector3.ZERO
	player_car.angular_velocity = Vector3.ZERO
	
	cam_controller.reset_view()

func on_track_spawned():
	total_spawned_tracks += 1
	# Start spawning enemies only a bit later in the game
	# if total_spawned_tracks > 2:
	#	Globals.spawn_enemies = true

func on_intro_ended():
	print("Intro ended")
	intro_animation_player.play("menu_in")

func on_menu_in_ended():
	game_state = GameState.MENU
	
	intro_animation_player.play("menu")
