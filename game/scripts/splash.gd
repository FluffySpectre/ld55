extends ColorRect

var fade_amount: float = 1.0

func _process(delta: float) -> void:
  fade_amount -= delta
  (material as ShaderMaterial).set_shader_parameter("fade_amount", fade_amount)
  if fade_amount <= 0.0:
    process_mode = Node.PROCESS_MODE_DISABLED
    visible = false
