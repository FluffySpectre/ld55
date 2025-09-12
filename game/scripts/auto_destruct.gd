class_name AutoDestruct extends Node

@export var delay: float = 3.0

func _ready() -> void:
  await get_tree().create_timer(delay).timeout
  get_parent().queue_free()
  print("Auto destructed!")
