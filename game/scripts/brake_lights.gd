extends Node3D

@onready var car_controller: CarController = get_parent()
@onready var brake_light_left = $BrakeLightLeft
@onready var brake_light_right = $BrakeLightRight

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if car_controller == null:
		return
	
	if car_controller.brake > 0:
		brake_light_left.visible = true
		brake_light_right.visible = true
	else:
		brake_light_left.visible = false
		brake_light_right.visible = false
