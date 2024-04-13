class_name TrackGenerator extends Node3D

@export var straight_street_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	generate()

func generate():
	var out_connector: Node3D
	
	for i in 100:
		var instance = straight_street_scene.instantiate() as Node3D
		add_child(instance)
		
		# Place the new street instance at the position and
		# rotation of the connector of the last street piece
		if out_connector:
			instance.global_position = out_connector.global_position
			instance.global_rotation = out_connector.global_rotation
		
		# Get connector for next street piece
		out_connector = instance.get_node("Connector") as Node3D
