class_name HealthVignette extends ColorRect

@export var critical_health_threshold: float = 25.0
@export var player_health: Health

var material_shader: ShaderMaterial
var pulse_tween: Tween
var current_base_radius: float = 0.0
var target_radius: float = 0.0
var is_game_over: bool = false

func _ready() -> void:
  #player_health = Globals.player_car.get_node("Health")
  player_health.on_health_changed.connect(on_player_health_changed)
  
  material_shader = material as ShaderMaterial
  update_target_radius()

func _process(delta: float) -> void:
  current_base_radius = lerp(current_base_radius, target_radius, delta)
  material_shader.set_shader_parameter("vignette_radius", current_base_radius)
  
  if player_health.health <= critical_health_threshold:
    if player_health.health > 0 && !pulse_tween:
      start_critical_pulse()
    elif player_health.health <= 0 && !is_game_over:
      game_over()  
    
  else:
    stop_critical_pulse()

func on_player_health_changed() -> void:
  update_target_radius()

func update_target_radius() -> void:
  var health_percentage = float(player_health.health) / float(player_health.max_health)
  target_radius = remap(health_percentage, 0.0, 1.0, 0.3, 0.7)
 
func start_critical_pulse() -> void:
  if pulse_tween:
    pulse_tween.kill()
  
  pulse_tween = create_tween()
  pulse_tween.set_loops()
  
  var health_percentage = float(player_health.health) / float(player_health.max_health)
  var base_intensity = remap(health_percentage, 0.0, 1.0, 0.4, 0.7)
  
  pulse_tween.tween_method(
    func(intensity): target_radius = intensity,
    base_intensity,
    min(base_intensity - 0.2, 0.4),
    1.0
  )
  pulse_tween.tween_method(
    func(intensity): target_radius = intensity,
    min(base_intensity - 0.2, 0.4),
    base_intensity,
    1.0
  )

func stop_critical_pulse() -> void:
  if pulse_tween:
    pulse_tween.kill()
    pulse_tween = null

func game_over() -> void:
  is_game_over = true
  
  if pulse_tween:
    pulse_tween.kill()
  
  pulse_tween = create_tween()
  
  pulse_tween.tween_method(
    func(intensity): target_radius = intensity,
    target_radius,
    0.0,
    2.0
  )
