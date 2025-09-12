class_name EnemyController extends Node

var car_controller: CarController
var player_car: CarController
var attack_distance: float = 50.0
var predict_time: float = 2.0
var interception_factor: float = 1.4

func _ready():
  car_controller = get_parent()

func _physics_process(delta):
  if !player_car:
    player_car = GameManager.instance.player_car
    return

  var predicted_position = predict_player_position(delta)
  perform_interception(predicted_position)

func predict_player_position(_delta: float) -> Vector3:
  var player_velocity = player_car.linear_velocity
  var predicted_position = player_car.global_position + (player_velocity * predict_time)
  return predicted_position

func perform_interception(predicted_position: Vector3):
  var direction_to_predicted = (predicted_position - car_controller.global_position).normalized()
  var distance_to_predicted = car_controller.global_position.distance_to(predicted_position)

  var target_position = predicted_position + (direction_to_predicted * attack_distance * interception_factor)
  var direction_to_target = (target_position - car_controller.global_position).normalized()
  
  var steer_direction = calculate_steering(direction_to_target)
  var acceleration = calculate_acceleration(distance_to_predicted, direction_to_target)

  car_controller.steer_input = steer_direction
  car_controller.acceleration_input = acceleration

func calculate_steering(direction_to_target: Vector3) -> float:
  var forward_direction = car_controller.global_transform.basis.z.normalized()
  var steer_angle = forward_direction.cross(direction_to_target).y
  return clamp(steer_angle, -1.0, 1.0)

func calculate_acceleration(distance_to_predicted: float, direction_to_target: Vector3) -> float:
  if direction_to_target.z < 0:
    return 1.0
  else:
    return -1.0
