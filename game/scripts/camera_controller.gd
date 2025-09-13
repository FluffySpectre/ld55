class_name CameraController extends Camera3D

@export var target: Node
@export var lerp_speed = 3.0
@export var offset = Vector3.ZERO

var noise: FastNoiseLite
var shake_intensity = 0.0
var shake_duration = 0.0
var shake_timer = 0.0
var noise_offset = 0.0

func _ready():
  noise = FastNoiseLite.new()
  noise.seed = randi()
  noise.frequency = 0.1

func reset_view():
  var target_pos = target.global_transform.translated_local(offset)
  global_position = target_pos.origin

#func _process(_delta: float) -> void:
  #if Input.is_action_just_pressed("ui_accept"):
    #shake_camera(0.6, 0.2)

func _physics_process(delta):
  if !target:
    return
  
  # Camera following behavior
  var target_pos = target.global_transform.translated_local(offset)
  global_transform = global_transform.interpolate_with(target_pos, lerp_speed * delta)
  
  # Apply screenshake if active
  var shake_offset = Vector3.ZERO
  if shake_timer > 0:
    shake_timer -= delta
    noise_offset += delta * 20.0
    
    var decay = shake_timer / shake_duration
    var current_intensity = shake_intensity * decay
    
    shake_offset = Vector3(
      noise.get_noise_1d(noise_offset) * current_intensity,
      noise.get_noise_1d(noise_offset + 100) * current_intensity,
      noise.get_noise_1d(noise_offset + 200) * current_intensity
    )
    
    # Apply shake offset to position
    global_position += shake_offset
  
  # Look at target (after shake is applied)
  look_at(target.global_position, Vector3.UP)

func shake_camera(intensity: float, duration: float):
  shake_intensity = intensity
  shake_duration = duration
  shake_timer = duration
