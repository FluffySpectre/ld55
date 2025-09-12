class_name EyesEnemy extends Node3D

@export var trigger_distance = 400.0
@export var speed = 20.0

var moving = false
var eyes = []

func _ready() -> void:
  eyes = get_children()
  var eye = eyes.pick_random() as Node
  eye.queue_free()

func _process(delta):
  if !Globals.player_car:
    return
  
  var player_position = Globals.player_car.global_position
  var distance_to_player = global_position.distance_to(player_position)
  
  if distance_to_player < trigger_distance:
    moving = true

  if moving:
    translate(Vector3.FORWARD * delta * speed)
