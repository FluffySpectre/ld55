class_name PlayerInput extends Node

@export var controllable = true

var parent: CarController

func _ready():
  parent = get_parent() as CarController
  
  if GameManager.instance:
    GameManager.instance.player_car = parent

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  if !controllable:
    parent.steer_input = 0.0
    parent.acceleration_input = 0.0
    return
  
  var steer_input = Input.get_axis("steer_right", "steer_left")
  var acceleration_input = Input.get_axis("brake", "accelerate")
  
  parent.steer_input = steer_input
  parent.acceleration_input = acceleration_input
