class_name BaseTrackPart extends Node3D

var track_part_data: TrackPartData

func _enter_tree() -> void:
  propagate_call("set_track_part_data", [track_part_data])
