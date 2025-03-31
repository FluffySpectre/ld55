extends Node

@export var particle_attractor_sphere: GPUParticlesAttractorSphere3D
@export var particle_repulsor_sphere: Node3D

var effect_duration = 5.0
var effect_timer = 0.0
var repulsor_active = false;

var do_heal = false
var heal_cooldown = 2.0

func _ready():
  toggle_repulsor(false)
  # toggle_attractor(true)
  
  GameManager.instance.pickup_picked_up.connect(on_pickup_picked_up)

func _process(delta):
  if repulsor_active:
    effect_timer += delta
    if effect_timer > effect_duration:
      Globals.player_car.get_node("Health").is_invincible = false
      # toggle_attractor(true)
      toggle_repulsor(false)
      effect_timer = 0.0

func on_pickup_picked_up(pickup_type):
  if pickup_type == 0:
    Globals.player_car.get_node("Health").is_invincible = true
    # toggle_attractor(false)
    toggle_repulsor(true)
    effect_timer = 0.0
  
  print("PICKUP PICKED UP. IMAGINE THAT! - type: " + str(pickup_type))

func toggle_attractor(enable):
  particle_attractor_sphere.visible = enable
  if enable:
    particle_attractor_sphere.process_mode = Node.PROCESS_MODE_INHERIT
  else:
    particle_attractor_sphere.process_mode = Node.PROCESS_MODE_DISABLED

func toggle_repulsor(enable):
  repulsor_active = enable
  particle_repulsor_sphere.visible = enable
  if enable:
    particle_repulsor_sphere.process_mode = Node.PROCESS_MODE_INHERIT
  else:
    particle_repulsor_sphere.process_mode = Node.PROCESS_MODE_DISABLED
