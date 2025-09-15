class_name GameManager extends Node

@export var player_car: CarController
@export var cam_controller: CameraController
@export var track_generator: TrackGenerator
@export var intro_animation_player: AnimationPlayer
@export var world_environment: WorldEnvironment
@export var gameover_animation_player: AnimationPlayer
@export var highscore_label: Label
@export var score_label: Label
@export var intro_track_sequence: TrackSequence

signal pickup_picked_up(type)
signal distance_changed(new_distance: float)

static var instance: GameManager

var start_position: Vector3 = Vector3.ZERO
var total_spawned_tracks = 0
var distance_interval = 100.0
var last_position = Vector3.ZERO
var distance_in_target_direction_interval = 0.0
var player_health: Health
var savegame: Savegame

enum GameState {
  INTRO,
  MENU,
  IN_GAME,
  GAME_OVER,
}
var game_state: GameState = GameState.INTRO
var state_changed: bool = false

func _ready():
  instance = self
  
  # Handle game quit ourselfs
  get_tree().set_auto_accept_quit(false)
  
  Globals.reset()
  
  savegame = Savegame.new()
  savegame.load()
  
  print("Loaded highscore: ", Globals.highscore)
  
  player_health = player_car.get_node("Health") as Health
  player_health.died.connect(on_player_died)
  
  Globals.player_car = player_car
  last_position = player_car.global_position

  Globals.camera_controller = cam_controller

  track_generator.on_track_spawned.connect(on_track_spawned)
  
  distance_changed.connect(check_enemy_spawn)
  
  gameover_animation_player.play("RESET")

func _notification(what):
  if what == NOTIFICATION_WM_CLOSE_REQUEST:
    quit_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  if player_car && start_position == Vector3.ZERO:
    start_position = player_car.global_position
    last_position = player_car.global_position
  
  if game_state == GameState.IN_GAME:
    if state_changed:
      state_changed = false
      
      track_generator.queue_track_sequence(intro_track_sequence)
    
    if Input.is_action_just_pressed("ui_cancel"):
      reset_player()
    
    update_score()
  
  if game_state == GameState.MENU:
    if Input.is_action_pressed("accelerate") || Input.is_action_pressed("brake") || Input.is_action_pressed("steer_left") || Input.is_action_pressed("steer_left"):
      start_game()
    elif Input.is_action_just_pressed("ui_cancel"):
      quit_game()
      
  if game_state == GameState.GAME_OVER:
    if state_changed:
      state_changed = false
      
      # Disable player input
      var player_input = player_car.get_node("PlayerInput") as PlayerInput
      player_input.controllable = false
      
      SoundManager.instance.fade_volume_out()
      
      if Globals.distance_in_target_direction > Globals.highscore:
        Globals.highscore = Globals.distance_in_target_direction
      
      gameover_animation_player.play("gameover")
      highscore_label.text = "Your longest drive so far:\n" + Utils.format_distance(Globals.highscore)
      score_label.text = "You survived " + Utils.format_distance(Globals.distance_in_target_direction) + "!"
    
      Globals.first_run = false
    
    if Input.is_action_just_pressed("ui_accept"):
      savegame.save()
      Globals.reset()
      get_tree().reload_current_scene()
    elif Input.is_action_just_pressed("ui_cancel"):
      quit_game()

func start_game():
  game_state = GameState.IN_GAME
  state_changed = true
  intro_animation_player.play("game_in")
  
  print("Game started")
  
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
    distance_in_target_direction_interval -= distance_interval
    
    if Globals.distance_in_target_direction > Globals.highscore:
      Globals.highscore = Globals.distance_in_target_direction
    
    distance_changed.emit(Globals.distance_in_target_direction)
    
  last_position = current_position

func reset_player():
  # TODO: Get the last track the player was driving on
  # and place the car there
  
  # Reload the entire scene for now
  savegame.save()
  Globals.reset()
  get_tree().reload_current_scene()
  return
  
  track_generator.reset_track()
  var first_track_part = track_generator.loaded_street_parts[0]
  
  player_car.global_position = first_track_part.global_position + Vector3(0, 0, 10.0)
  player_car.global_rotation_degrees = Vector3.ZERO
  player_car.linear_velocity = Vector3.ZERO
  player_car.angular_velocity = Vector3.ZERO
  
  cam_controller.reset_view()

func check_enemy_spawn(new_distance: float):
  # Start spawning enemies after fog sets in
  if new_distance >= 1500.0:
    Globals.spawn_enemies = true

func on_track_spawned(track_part_data: TrackPartData):
  total_spawned_tracks += 1
  apply_track_part_effects(track_part_data)

func apply_track_part_effects(track_part_data: TrackPartData):
  #Globals.spawn_enemies = track_part_data.spawn_enemies
  pass

func on_intro_ended():
  print("Intro ended")
  intro_animation_player.play("menu_in")

func on_menu_in_ended():
  game_state = GameState.MENU
  state_changed = true
  
  intro_animation_player.play("menu")

func on_player_died() -> void:
  if game_state == GameState.GAME_OVER:
    return
  
  game_state = GameState.GAME_OVER
  state_changed = true
  print("Game Over")
  
func quit_game() -> void:
  print("Quitting...")
  savegame.save()
  get_tree().quit()
