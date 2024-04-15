class_name TrackGenerator extends Node3D

@export var street_part_scenes: Array[PackedScene]
@export var player_car: Node3D

var num_parts_to_load = 5
var loaded_street_parts = []
var last_out_connector: Node3D
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_track()

func _process(_delta):
	generate()
	destroy_out_of_screen_street_parts()

func get_street_part_scene():
	return street_part_scenes[rng.randi_range(0, street_part_scenes.size() - 1)]

func spawn_street_part():
	var instance = get_street_part_scene().instantiate() as Node3D
	add_child(instance)
	loaded_street_parts.append(instance)
	
	# Place the new street instance at the position and
	# rotation of the connector of the last street piece
	if last_out_connector:
		instance.global_position = last_out_connector.global_position
		instance.global_rotation = last_out_connector.global_rotation
	
	# Get connector for next street piece
	last_out_connector = instance.get_node("Connector") as Node3D

func generate():
	for i in range(loaded_street_parts.size(),num_parts_to_load):
		spawn_street_part()

func destroy_out_of_screen_street_parts():
	# Iterate (backwards) over all loaded street parts and destroy the parts which
	# are behind the player and out of screen
	for i in range(loaded_street_parts.size()-1,0,-1):
		var part = loaded_street_parts[i] as Node3D
		var on_screen_notifier = part.get_node("VisibleOnScreenNotifier3D") as VisibleOnScreenNotifier3D
		var is_on_screen = on_screen_notifier.is_on_screen()
		var is_behind_player = part.global_position.z < player_car.global_position.z
		
		if !is_on_screen && is_behind_player:
			loaded_street_parts.pop_at(i)
			part.queue_free()

func reset_track():
	# Destroy all loaded street parts first
	for i in range(loaded_street_parts.size()-1,0,-1):
		var part = loaded_street_parts.pop_at(i)
		part.queue_free()
	
	last_out_connector = null
	
	rng = RandomNumberGenerator.new()
	
	generate()
