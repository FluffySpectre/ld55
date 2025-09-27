extends Node3D

@export var tree_scene: PackedScene
@export var spawns_per_frame = 5
@export var num_trees = 100
@export var group_chance = 0.1
@export var group_radius = 20
@export var trees_per_group = 5
@export_group("Size variation")
@export var min_size = 0.75
@export var max_size = 1.25

@onready var spawn_area_shape: CollisionShape3D = $Area3D/CollisionShape3D

var _spawns_needed: int

func _ready():
  _spawns_needed = num_trees
  randomize()
  #spawn_trees()

func _process(_delta: float) -> void:
  if spawns_per_frame > -1 && _spawns_needed > 0:
    _spawns_needed -= spawns_per_frame
    spawn_trees(spawns_per_frame)
    
func get_random_point_in_area():
  var extents = spawn_area_shape.shape.extents
  var min_extent = -extents
  var max_extent = extents
  return spawn_area_shape.global_position + Vector3(randf_range(min_extent.x, max_extent.x), randf_range(min_extent.y, max_extent.y), randf_range(min_extent.z, max_extent.z))

func spawn_trees(num: int):
  for i in range(num):
    if randf() < group_chance:
      spawn_tree_group(get_random_point_in_area(), trees_per_group)
    else:
      spawn_tree(get_random_point_in_area())

func spawn_tree(pos: Vector3):
  var tree = tree_scene.instantiate() as Node3D
  add_child(tree)
  tree.global_position = pos
  tree.rotate_y(randf_range(0.0, 360.0))
  tree.scale = Vector3.ONE * randf_range(min_size, max_size)

func spawn_tree_group(center, count):
  for i in range(count):
    var pos = center + Vector3(randf_range(-group_radius, group_radius), 0, randf_range(-group_radius, group_radius))
    spawn_tree(pos)
