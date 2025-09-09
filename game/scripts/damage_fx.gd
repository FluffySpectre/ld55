extends Node

@export var car_body_mesh: MeshInstance3D
@export var dissolve_material: ShaderMaterial

@onready var car_controller: CarController = get_parent()

var health: Health
var initial_engine_power: float
var current_shader_threshold: float = 0.0
var target_shader_threshold: float = 0.0

func _ready():
  health = get_node("../Health") as Health
  health.on_health_changed.connect(on_health_changed)
  
  initial_engine_power = car_controller.engine_power
  
  car_body_mesh.set_surface_override_material(2, dissolve_material)
  dissolve_material.set_shader_parameter("threshold", 0.0)

func _process(delta: float) -> void:
  current_shader_threshold = lerp(current_shader_threshold, target_shader_threshold, delta)
  dissolve_material.set_shader_parameter("threshold", current_shader_threshold)

func on_health_changed():
  var health_percent = float(health.health) / float(health.max_health)

  target_shader_threshold = 1.0 - health_percent

  # Adjust speed
  car_controller.engine_power = minf(2000.0 + health_percent * (initial_engine_power - 2000.0), initial_engine_power)
  
