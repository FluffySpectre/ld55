class_name Obscurus extends Node3D

@export var trigger_distance = 50.0
@export var min_speed = 25.0
@export var max_speed = 40.0

enum BehaviourState {
	IDLE,
	CHASING,
	ATTACKING
}
var state: BehaviourState = BehaviourState.IDLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Globals.player_car:
		return
	
	var target_position = Globals.player_car.global_position
	var distance = global_position.distance_to(target_position)
	
	if distance < trigger_distance:
		# Calculate the movement speed based on the distance
		var speed = lerp(min_speed, max_speed, (trigger_distance - distance) / trigger_distance)
		global_position = global_position.move_toward(target_position, delta * speed)
