class_name TrackGenerator extends Node3D

@export var street_part_scenes: Array[PackedScene]
@export var player_car: Node3D

signal on_track_spawned

@onready var track_collider: CollisionShape3D = $TrackCollider/CollisionShape3D
@onready var track_collider_particles: GPUParticlesCollisionBox3D = $TrackCollider/GPUParticlesCollisionBox3D

var num_parts_to_load = 8
var loaded_street_parts = []
var last_out_connector: Node3D
var rng = RandomNumberGenerator.new()
var first_frame = true

# Called when the node enters the scene tree for the first time.
func _ready():
  reset_track()

func _process(_delta):
  generate()
  
  if !first_frame:
    destroy_out_of_screen_street_parts()
    
  first_frame = false

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
  
  # Increase the dimensions of the track collider
  resize_track_collider()
  
  # Emit track spawned signal
  on_track_spawned.emit()

func generate():
  for i in range(loaded_street_parts.size(),num_parts_to_load):
    spawn_street_part()

func destroy_out_of_screen_street_parts():
  # Iterate (backwards) over all loaded street parts and destroy the parts which
  # are behind the player and out of screen
  for i in range(loaded_street_parts.size()-1,-1,-1):
    var part = loaded_street_parts[i] as Node3D
    var on_screen_notifier = part.get_node("VisibleOnScreenNotifier3D") as VisibleOnScreenNotifier3D
    var is_on_screen = on_screen_notifier.is_on_screen()
    var is_behind_player = part.global_position.z < player_car.global_position.z
    
    if !is_on_screen && is_behind_player:
      loaded_street_parts.pop_at(i)
      part.queue_free()
  
  resize_track_collider()

func reset_track():
  # Destroy all loaded street parts first
  for i in range(loaded_street_parts.size()-1,0,-1):
    var part = loaded_street_parts.pop_at(i)
    part.queue_free()
  
  last_out_connector = null
  
  rng = RandomNumberGenerator.new()
  
  generate()

func resize_track_collider():
  # Get all loaded track parts (children of this node) in child order
  var track_parts = get_children()
  
  # Get the first and last track parts out of the list
  # First child is the TrackCollider, so ignore this
  var first_part = track_parts[1]
  var last_part = track_parts[track_parts.size() - 1]
  
  # Calculate the distance between the global_position of the first
  # track part and the connectors global_position of the last track part
  # Assuming 'connector' is a node that represents the connection point
  var first_pos = first_part.global_position
  var last_pos = last_part.get_node("Connector").global_position
  var distance = first_pos.distance_to(last_pos)
  
  # Update the collider sizes
  # Set the z-Part of the size of the track collider to the calculated distance value
  var collider_size = track_collider.shape.size
  collider_size.z = distance
  track_collider.shape.size = collider_size

  # Adjust the position of the collider to be centered between the first and last parts
  var new_position = first_pos.lerp(last_pos, 0.5)
  track_collider.global_position = new_position
  
  # Set the z-Part of the size of the track collider to the calculated distance value
  collider_size = track_collider_particles.size
  collider_size.z = distance
  track_collider_particles.size = collider_size

  # Adjust the position of the collider to be centered between the first and last parts
  track_collider_particles.global_position = new_position
