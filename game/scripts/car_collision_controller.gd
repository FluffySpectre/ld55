class_name CarCollisionController extends Node

@export var impact_strength_multiplier = 150.0
@export var impact_sound_fx: Array[AudioStream]

@onready var car_controller: CarController = get_parent()

var rng = RandomNumberGenerator.new()

func _physics_process(delta):
  var bodies = car_controller.get_colliding_bodies()

  var cars = bodies.filter(func(b): return b is CarController)
  if cars.size() > 0:
    for i in cars.size():
      apply_impact_force(cars[i])
      play_impact_sound_fx()

func apply_impact_force(body: VehicleBody3D):
  # Calculate the direction of the impact
  var impact_direction = (body.global_position - car_controller.global_position).normalized()
  var relative_velocity = (body.linear_velocity - get_parent().linear_velocity).length()
  
  # Calculate impact force
  var impact_strength = relative_velocity * impact_strength_multiplier
  var impact_force = impact_direction * impact_strength
  
  # printt("Impact force: ", impact_force)
  
  # Apply the calculated force
  body.apply_impulse(impact_force)

func play_impact_sound_fx():
  if impact_sound_fx.size() == 0:
    return
  var random_fx = impact_sound_fx[rng.randi_range(0, impact_sound_fx.size()-1)]
  SoundManager.instance.play(random_fx)
