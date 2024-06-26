class_name Spawner extends Node3D

@export var scenes_to_spawn: Array[PackedScene]
@export var spawn_area: Area3D
@export var spawn_offset = Vector3(0, 0, 0)
@export var chance_for_spawn = 0.05

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	if (!Globals.spawn_enemies):
		return
		
	spawn()

func get_random_scene_to_spawn():
	return scenes_to_spawn[rng.randi_range(0, scenes_to_spawn.size() - 1)]

func get_random_point_in_area():
	var collision_shape = spawn_area.get_node("CollisionShape3D") as CollisionShape3D
	var extents = collision_shape.shape.extents
	var min_extent = -extents
	var max_extent = extents
	return collision_shape.global_position + Vector3(randf_range(min_extent.x, max_extent.x), randf_range(min_extent.y, max_extent.y), randf_range(min_extent.z, max_extent.z))
	
func spawn():
	if rng.randf() > chance_for_spawn:
		return
	
	var instance = get_random_scene_to_spawn().instantiate() as Node3D
	add_child(instance)
	instance.global_position = get_random_point_in_area()
