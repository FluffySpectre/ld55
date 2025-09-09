extends Node

var player_car: CarController
var spawn_enemies = false
var score: int = 0
var distance_in_target_direction = 0.0
var fog_density = 0.0

func reset() -> void:
  player_car = null
  spawn_enemies = false
  score = 0
  distance_in_target_direction = 0.0
  fog_density = 0.0
