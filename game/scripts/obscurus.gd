class_name Obscurus extends CharacterBody3D

@export var trigger_distance = 40.0
@export var stopping_distance = 3.0
@export var damage_interval = 0.25
@export var damage_per_interval = 1

@onready var attackAreaContainer: Node3D = $AttackAreaContainer
@onready var attackArea: Area3D = $AttackAreaContainer/AttackArea

enum BehaviourState {
	IDLE,
	CHASING,
	ATTACKING
}
var state: BehaviourState = BehaviourState.IDLE
var state_changed = false

var spawn_position = Vector3.ZERO
var idle_target_position = Vector3.ZERO
var hitting_player = false
var damage_timer = 0.0
var player_health: Health 

func _ready():
	spawn_position = global_position
	idle_target_position = Vector3(spawn_position.x + randf_range(-10.0, 10.0), spawn_position.y, spawn_position.z + randf_range(-10.0, 10.0))
	
	attackArea.area_entered.connect(on_attack_area_entered)
	attackArea.area_exited.connect(on_attack_area_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !Globals.player_car:
		return
	
	if Globals.player_car and player_health == null:
		player_health = Globals.player_car.get_node("Health") as Health
	
	var player_position = Globals.player_car.global_position
	var distance_to_player = global_position.distance_to(player_position)
	
	if state == BehaviourState.IDLE:
		if distance_to_player < trigger_distance:
			state = BehaviourState.CHASING
			state_changed = true
		# else:
			# var distance_to_idle_target = global_position.distance_to(idle_target_position)
			# if distance_to_idle_target > 0.1:
			# 	move_towards_target(idle_target_position, delta)
			# else:
			#	idle_target_position = Vector3(spawn_position.x + randf_range(-10.0, 10.0), spawn_position.y, spawn_position.z + randf_range(-10.0, 10.0))
			
	elif state == BehaviourState.CHASING:
		if state_changed:
			state_changed = false
		
		if distance_to_player > stopping_distance:
			move_towards_target(player_position, delta)
			
		if hitting_player:
			damage_timer += delta
			if damage_timer > damage_interval:
				player_health.apply_damage(damage_per_interval)
				damage_timer = 0.0

func move_towards_target(target_position, delta):
	var speed = 2.0
	var target_dir = target_position - global_position
	move_and_collide(target_dir * speed * delta)
	
	# Look at (attack area only)
	var current_angle = attackAreaContainer.rotation.y
	var target_angle = atan2(target_dir.x, target_dir.z) + PI
	var smoothed_angle = lerp_angle(current_angle, target_angle, delta * 4.0)
	attackAreaContainer.rotation.y = smoothed_angle

func on_attack_area_entered(body: CollisionObject3D):
	if Globals.player_car != body.get_parent():
		return
	
	hitting_player = true

func on_attack_area_exited(body: CollisionObject3D):
	if Globals.player_car != body.get_parent():
		return

	hitting_player = false
	
