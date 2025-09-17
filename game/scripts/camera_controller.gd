class_name CameraController extends Camera3D

@export var target: Node
@export var lerp_speed = 3.0
@export var offset = Vector3.ZERO

@export_group("Attention system")
@export var attention_target: Node3D
@export var attention_weight: float = 0.3 # How much to pull camera towards the attention target
@export var max_attention_distance: float = 50.0
@export var attention_transition_speed: float = 2.0
@export var attention_reset_transition_speed: float = 0.5

@export_group("Camera Shake")
@export var shake_decay_rate: float = 1.0

var current_attention_weight: float = 0.0
var last_attention_position: Vector3
var shake_intensity: float = 0.0
var shake_duration: float = 0.0
var shake_timer: float = 0.0

func reset_view():
  var target_pos = target.global_transform.translated_local(offset)
  global_position = target_pos.origin

func shake_camera(amount: float, duration: float) -> void:
  shake_intensity = amount
  shake_duration = duration
  shake_timer = duration

func _get_shake_offset() -> Vector3:
  if shake_timer <= 0.0:
    return Vector3.ZERO
  
  var current_intensity = shake_intensity * (shake_timer / shake_duration)
  
  var shake_offset = Vector3(
    randf_range(-current_intensity, current_intensity),
    randf_range(-current_intensity, current_intensity),
    randf_range(-current_intensity, current_intensity)
  )
  
  return shake_offset

func _physics_process(delta):
  if !target:
    return
  
  # FOR TESTING
  #if Input.is_action_just_pressed("ui_accept"):
    #shake_camera(1.0, 0.2)
  
  # Update shake timer
  if shake_timer > 0.0:
    shake_timer -= delta * shake_decay_rate
    if shake_timer < 0.0:
      shake_timer = 0.0
  
  # Update camera position (following the primary target)
  var target_pos = target.global_transform.translated_local(offset)
  global_transform = global_transform.interpolate_with(target_pos, lerp_speed * delta)
  
  # Apply camera shake to position
  var shake_offset = _get_shake_offset()
  global_position += shake_offset
  
  # Calculate look-at position with attention target
  var look_at_position = calculate_look_at_position(delta)
  look_at(look_at_position, Vector3.UP)

func calculate_look_at_position(delta: float) -> Vector3:
  var primary_position = target.global_position
  
  if attention_target:
    last_attention_position = attention_target.global_position
    
    # Calculate distance-based attention factor
    var distance_to_attention = target.global_position.distance_to(attention_target.global_position)
    var distance_factor = 1.0 - clamp(distance_to_attention / max_attention_distance, 0.0, 1.0)
    
    # Calculate target attention weight based on distance
    var target_attention_weight = attention_weight * distance_factor
    
    # Smoothly transition to target weight
    current_attention_weight = move_toward(current_attention_weight, target_attention_weight, attention_transition_speed * delta)
    
    # Calculate weighted look at position
    return primary_position.lerp(last_attention_position, current_attention_weight)
  
  else:
    current_attention_weight = move_toward(current_attention_weight, 0.0, attention_reset_transition_speed * delta)
    
    if current_attention_weight > 0.0:
      return primary_position.lerp(last_attention_position, current_attention_weight)
    
    return primary_position
