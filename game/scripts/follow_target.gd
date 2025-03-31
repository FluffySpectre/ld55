extends Node3D

@export var target: Node3D
@export var offset: Vector3 = Vector3.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  global_position = target.global_position + offset
