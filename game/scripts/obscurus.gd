class_name Obscurus extends Node3D

@export var sense_distance = 50.0
@export var move_speed = 10.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Globals.player_car:
		return
		
	var distance = global_transform.origin.distance_to(Globals.player_car.global_transform.origin)
	
	if distance < sense_distance:
		global_position = global_position.move_toward(Globals.player_car.global_transform.origin, delta * move_speed)
