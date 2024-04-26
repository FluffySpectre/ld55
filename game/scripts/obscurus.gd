class_name Obscurus extends CharacterBody3D

@export var trigger_distance = 40.0
@export var stopping_distance = 3.0

enum BehaviourState {
	IDLE,
	CHASING,
	ATTACKING
}
var state: BehaviourState = BehaviourState.IDLE

var spawn_position = Vector3.ZERO
var idle_target_position = Vector3.ZERO

func _ready():
	spawn_position = global_position
	idle_target_position = Vector3(spawn_position.x + randf_range(-10.0, 10.0), spawn_position.y, spawn_position.z + randf_range(-10.0, 10.0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !Globals.player_car:
		return
	
	var player_position = Globals.player_car.global_position
	var distance_to_player = global_position.distance_to(player_position)
	
	if state == BehaviourState.IDLE:
		if distance_to_player < trigger_distance:
			state = BehaviourState.CHASING
		# else:
			# var distance_to_idle_target = global_position.distance_to(idle_target_position)
			# if distance_to_idle_target > 0.1:
			# 	move_towards_target(idle_target_position, delta)
			# else:
			#	idle_target_position = Vector3(spawn_position.x + randf_range(-10.0, 10.0), spawn_position.y, spawn_position.z + randf_range(-10.0, 10.0))
			
	elif state == BehaviourState.CHASING:
		if distance_to_player > stopping_distance:
			move_towards_target(player_position, delta)

func move_towards_target(target_position, delta):
	var speed = 2.0
	var target_dir = target_position - global_position
	move_and_collide(target_dir * speed * delta)
