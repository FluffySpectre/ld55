class_name Eye extends Node3D

@export var powerloss_time: float = 0.5
@export var splatter_fx_scene: PackedScene

@onready var collision_area: Area3D = $Area3D

var original_engine_power: float = 0.0
var powerloss_timer: float = 0.0
var car_controller: CarController
var player_input: PlayerInput

func _ready() -> void:
  collision_area.body_entered.connect(on_body_entered)

func _process(delta: float) -> void:
  if powerloss_timer > 0:
    powerloss_timer -= delta
    
    car_controller.acceleration_input = -1.0
    
    if powerloss_timer <= 0:
      #car_controller.engine_power = original_engine_power
      player_input.controllable = true

func on_body_entered(other: Node3D) -> void:
  if other is CarController:
    car_controller = other
    #original_engine_power = car_controller.engine_power
    #car_controller.engine_power *= 0.1
    var player_health = car_controller.get_node("Health") as Health
    if !player_health.is_invincible:
      player_input = car_controller.get_node("PlayerInput") as PlayerInput
      player_input.controllable = false
      powerloss_timer = powerloss_time
      
      player_health.apply_damage(20)
    
    destroy()

func destroy() -> void:
  var splatter = splatter_fx_scene.instantiate() as Node3D
  get_tree().root.add_child(splatter)
  splatter.global_position = global_position
  
  visible = false
  
  await get_tree().create_timer(powerloss_time + 0.1).timeout
  
  queue_free()
