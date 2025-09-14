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

var current_attention_weight: float = 0.0
var last_attention_position: Vector3

func reset_view():
  var target_pos = target.global_transform.translated_local(offset)
  global_position = target_pos.origin

func _physics_process(delta):
  if !target:
    return
  
  # Update camera position (following the primary target)
  var target_pos = target.global_transform.translated_local(offset)
  global_transform = global_transform.interpolate_with(target_pos, lerp_speed * delta)
  
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
