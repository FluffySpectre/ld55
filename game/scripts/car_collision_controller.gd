class_name CarCollisionController extends Area3D

func _ready():
	connect("body_entered", _on_collision_area_body_entered)

func _on_collision_area_body_entered(body):
	if body is CarController:
		apply_impact_force(body)

func apply_impact_force(body: VehicleBody3D):
	# Calculate the direction of the impact
	var impact_direction = (body.global_transform.origin - global_transform.origin).normalized()
	var relative_velocity = (body.linear_velocity - get_parent().linear_velocity).length()
	
	# Calculate impact force
	var impact_strength = relative_velocity * 250.0 # Multiplikator anpassen für gewünschte Effektstärke
	var impact_force = impact_direction * impact_strength
	
	printt("Impact force: ", impact_force)
	
	# Apply the calculated force
	body.apply_impulse(impact_force)
