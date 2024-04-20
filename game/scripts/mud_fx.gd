extends Node3D

@onready var car_controller: CarController = get_parent()
@onready var mud_particles_left: GPUParticles3D = $MudParticlesLeft
@onready var mud_particles_right: GPUParticles3D = $MudParticlesRight

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if car_controller == null || car_controller.linear_velocity.length() < 0.05:
		mud_particles_left.emitting = false
		mud_particles_right.emitting = false
		return
	
	mud_particles_left.emitting = !car_controller.left_on_street
	mud_particles_right.emitting = !car_controller.right_on_street
