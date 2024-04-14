extends Node3D

@onready var car_controller: CarController = get_parent()
@onready var brake_light_left = $BrakeLightLeft
@onready var brake_light_right = $BrakeLightRight
@onready var brake_particles_left: GPUParticles3D = $BrakeParticlesLeft
@onready var brake_particles_right: GPUParticles3D = $BrakeParticlesRight

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if car_controller == null:
		return
	
	if car_controller.brake > 0 && car_controller.linear_velocity.length() > 0.05:
		brake_light_left.visible = true
		brake_light_right.visible = true
		
		brake_particles_left.emitting = true
		brake_particles_right.emitting = true
	else:
		brake_light_left.visible = false
		brake_light_right.visible = false
		
		brake_particles_left.emitting = false
		brake_particles_right.emitting = false
