extends Node

var player_car: CarController
var camera_controller: CameraController
var spawn_enemies = false
var distance_in_target_direction = 0.0
var highscore = 0.0
var fog_density = 0.0
var first_run = true

func reset() -> void:
  player_car = null
  camera_controller = null
  spawn_enemies = false
  distance_in_target_direction = 0.0
  #highscore = 0.0 # The highscore persists
  fog_density = 0.0
