extends Node3D

@export var tree_scene: PackedScene
@export var num_trees = 100
@export var group_chance = 0.1
@export var group_radius = 20
@export var trees_per_group = 5

@onready var spawn_area: Area3D = $Area3D

func _ready():
	randomize()
	spawn_trees()

func get_random_point_in_area():
	var collision_shape = spawn_area.get_node("CollisionShape3D") as CollisionShape3D
	var extents = collision_shape.shape.extents
	var min_extent = -extents
	var max_extent = extents
	return collision_shape.global_position + Vector3(randf_range(min_extent.x, max_extent.x), randf_range(min_extent.y, max_extent.y), randf_range(min_extent.z, max_extent.z))

func spawn_trees():
	for i in range(num_trees):
		if randf() < group_chance:
			spawn_tree_group(get_random_point_in_area(), trees_per_group)
		else:
			spawn_tree(get_random_point_in_area())

func spawn_tree(position):
	var tree = tree_scene.instantiate() as Node3D
	add_child(tree)
	tree.global_position = position
	tree.rotate_y(randf_range(0.0, 360.0))
	tree.scale = Vector3.ONE * randf_range(0.75, 1.25)

func spawn_tree_group(center, count):
	for i in range(count):
		var pos = center + Vector3(randf_range(-group_radius, group_radius), 0, randf_range(-group_radius, group_radius))
		spawn_tree(pos)

