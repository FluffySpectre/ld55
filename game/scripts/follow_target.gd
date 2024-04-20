extends Node3D

@export var target: Node3D
@export var smooth_move = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if smooth_move:
		smooth_move_to_target(delta)
		return
	
	global_position = target.global_position

func smooth_move_to_target(delta):
	global_position = global_position.move_toward(target.global_position, delta * 2.0)
