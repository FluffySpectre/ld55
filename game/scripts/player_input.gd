class_name PlayerInput extends Node

func _ready():
	GameManager.player_car = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var steer_input = Input.get_axis("steer_right", "steer_left")
	var acceleration_input = Input.get_axis("brake", "accelerate")
	
	get_parent().steer_input = steer_input
	get_parent().acceleration_input = acceleration_input
