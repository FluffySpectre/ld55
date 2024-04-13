class_name Bullet extends RigidBody3D

@export var car_rigidbody: RigidBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Adjust the speed of the bullet to the speed of the car
	var car_speed = car_rigidbody.linear_velocity.length()
	add_constant_central_force(position.normalized() * car_speed * 0.25)
