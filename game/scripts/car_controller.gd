class_name CarController extends VehicleBody3D

@export var engine_power = 3000.0
@export var max_steer = 15.0
@export var brake_power = 15.0
@export var max_speed = 100.0
# Steering smoothing
@export var steering_smoothness = 10.0
@export var speed_dependent_steering = 0.2

# Inputs
@export var steer_input = 0.0
@export var acceleration_input = 0.0

@onready var raycast_left: RayCast3D = $RayCastLeft
@onready var raycast_right: RayCast3D = $RayCastRight

var underground_friction = 1.0
var left_on_street = false
var right_on_street = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var velocity = linear_velocity.length()

	# Adjustment of the steering factor in dependence of the speed
	var speed_adjustment = clamp(1.0 - (velocity * speed_dependent_steering), 0.15, 1.0)

	if steer_input == 0:
		var current_forward = global_transform.basis.z.normalized()
		var desired_forward = Vector3(0, 0, 1)
		
		# Calculate delta angle between the current direction and the forward direction
		var angle_diff = atan2(current_forward.cross(desired_forward).y, current_forward.dot(desired_forward))
		
		var target_steering = clamp(angle_diff / deg_to_rad(max_steer), -1, 1) * speed_adjustment * 0.4
		
		# HACK: Fix the steering angle to drive exactly forward
		# I never touching the calculation above ever again, so this needs to suffice
		target_steering += 0.0037
		
		# Lerp the steering towards the desired direction
		steering = move_toward(steering, target_steering, steering_smoothness * delta)
	else:
		# We got steering input, so set it (including the speed adjustment)
		var adjusted_input = speed_adjustment * steer_input * deg_to_rad(max_steer)
		steering = move_toward(steering, adjusted_input, steering_smoothness * delta)
	
	var new_engine_force = 0.0
	if acceleration_input > 0:
		if velocity < max_speed:
			# Reduce the engine power as the vehicle approaches its maximum speed
			var approach_factor = max(0, 1 - (velocity / max_speed))
			new_engine_force = acceleration_input * engine_power * approach_factor
			brake = 0.0
		else:
			# Prevent further acceleration once the maximum speed is reached
			new_engine_force = 0
	elif acceleration_input < 0:
		# Do braking
		var brake_intensity = -acceleration_input
		brake = brake_power * brake_intensity
	else:
		new_engine_force = 0
		
	# Apply underground friction
	underground_friction = detect_underground_friction()
	engine_force = new_engine_force * underground_friction

func detect_underground_friction():
	if !raycast_left || !raycast_right:
		left_on_street = true
		right_on_street = true
		return 1.0
	
	# Check both raycasts
	var street_hits = 0
	left_on_street = false
	right_on_street = false
	if raycast_left.is_colliding():
		var colliderLeft = raycast_left.get_collider()
		if colliderLeft.name == "StreetCollider":
			street_hits += 1
			left_on_street = true
	
	if raycast_right.is_colliding():
		var colliderRight = raycast_right.get_collider()
		if colliderRight.name == "StreetCollider":
			street_hits += 1
			right_on_street = true
	
	var friction_factors = [0.7, 0.8, 1.0]
	return friction_factors[street_hits]
