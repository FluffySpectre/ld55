extends Node3D

@export var target: Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	global_position = target.global_position
