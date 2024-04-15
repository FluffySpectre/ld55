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
		
		# Lerp the steering towards the desired direction
		steering = move_toward(steering, target_steering, steering_smoothness * delta)
	else:
		# We got steering input, so set it (including the speed adjustment)
		var adjusted_input = speed_adjustment * steer_input * deg_to_rad(max_steer)
		steering = move_toward(steering, adjusted_input, steering_smoothness * delta)
	
	if acceleration_input > 0:
		if velocity < max_speed:
			# Reduce the engine power as the vehicle approaches its maximum speed
			var approach_factor = max(0, 1 - (velocity / max_speed))
			engine_force = acceleration_input * engine_power * approach_factor
			brake = 0.0
		else:
			# Prevent further acceleration once the maximum speed is reached
			engine_force = 0
	elif acceleration_input < 0:
		# Do braking
		var brake_intensity = -acceleration_input
		brake = brake_power * brake_intensity
	else:
		engine_force = 0

