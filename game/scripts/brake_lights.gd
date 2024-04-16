extends Node3D

@onready var car_controller: CarController = get_parent()
@onready var brake_light_left: Light3D = $BrakeLightLeft
@onready var brake_light_right: Light3D = $BrakeLightRight
@onready var brake_particles_left: GPUParticles3D = $BrakeParticlesLeft
@onready var brake_particles_right: GPUParticles3D = $BrakeParticlesRight

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if car_controller == null:
		return
	
	if car_controller.brake > 0 && car_controller.linear_velocity.length() > 0.05:
		brake_light_left.light_energy = 1.0
		brake_light_right.light_energy = 1.0
		
		brake_particles_left.emitting = true
		brake_particles_right.emitting = true
	else:
		brake_light_left.light_energy = 0.3
		brake_light_right.light_energy = 0.3
		
		brake_particles_left.emitting = false
		brake_particles_right.emitting = false
