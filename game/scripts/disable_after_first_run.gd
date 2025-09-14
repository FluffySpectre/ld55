class_name DisableAfterFirstRun extends Node

@onready var parent: Node3D = get_parent() as Node3D

func _process(_delta: float) -> void:
  if !Globals.first_run:
    parent.process_mode = Node.PROCESS_MODE_DISABLED
    parent.visible = false
  
  process_mode = Node.PROCESS_MODE_DISABLED
