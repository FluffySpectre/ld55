extends Node

@export var car_body: MeshInstance3D

@onready var car_controller: CarController = get_parent()

var health: Health
var initial_engine_power: float

func _ready():
  health = get_node("../Health") as Health
  health.on_health_changed.connect(on_health_changed)
  
  initial_engine_power = car_controller.engine_power

func on_health_changed():
  var health_percent = float(health.health) / float(health.max_health)
  
  # Adjust color
  var alpha = 1.0 - health_percent
  if alpha > 0.95:
    alpha = 0.95
  car_body.material_overlay.albedo_color.a = alpha

  # Adjust speed
  car_controller.engine_power = minf(2000.0 + health_percent * (initial_engine_power - 2000.0), initial_engine_power)
  
