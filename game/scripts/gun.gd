class_name Gun extends Node3D

@export var bullet_scene: PackedScene
@export var bullet_speed = 15.0
@export var shoot_delay = 0.1
@export var car_rigidbody: RigidBody3D

@onready var left_barrel: Node3D = $BarrelLeft
@onready var right_barrel: Node3D = $BarrelRight

var shoot_timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if Input.is_action_pressed("shoot_gun"):
    shoot_timer += delta
    if shoot_timer >= shoot_delay:
      shoot()
      shoot_timer = 0.0
  else:
    shoot_timer = 0.0

func shoot():
  var instance = bullet_scene.instantiate() as Bullet
  instance.top_level = true
  instance.car_rigidbody = car_rigidbody
  instance.global_position = left_barrel.global_position
  get_tree().root.add_child(instance)
  
  instance = bullet_scene.instantiate() as Bullet
  instance.top_level = true
  instance.car_rigidbody = car_rigidbody
  instance.global_position = right_barrel.global_position
  get_tree().root.add_child(instance)
