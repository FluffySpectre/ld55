extends ColorRect

func _process(delta: float) -> void:
  color.a -= delta
  if color.a <= 0.0:
    process_mode = Node.PROCESS_MODE_DISABLED
    visible = false
