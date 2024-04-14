class_name Spawner extends Node3D

@export var scenes_to_spawn: Array[PackedScene]
@export var spawn_area: Area3D
@export var chance_for_spawn = 0.05

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn()

func get_random_scene_to_spawn():
	return scenes_to_spawn[rng.randi_range(0, scenes_to_spawn.size() - 1)]

func get_random_point_in_area():
	var area_collision_shape = spawn_area.get_node("CollisionShape3D") as CollisionShape3D
	var size_halfed = area_collision_shape.shape.size * 0.5
	var random_point = Vector3(rng.randf_range(-size_halfed.x, size_halfed.x), rng.randf_range(-size_halfed.y, size_halfed.y), rng.randf_range(-size_halfed.z, size_halfed.z))
	return spawn_area.global_position + random_point

func spawn():
	if rng.randf() > chance_for_spawn:
		return
	
	var instance = get_random_scene_to_spawn().instantiate() as Node3D
	add_child(instance)
	instance.global_position = get_random_point_in_area()
