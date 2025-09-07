extends Node3D

var prewarm_frames_counter: int = 60

func _process(_delta: float) -> void:
  prewarm_frames_counter -= 1
  if prewarm_frames_counter <= 0:
    get_tree().change_scene_to_file("res://main.tscn")
    process_mode = Node.PROCESS_MODE_DISABLED
