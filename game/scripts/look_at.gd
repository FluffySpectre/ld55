class_name LookAt extends Node

@export var target: Node3D

@onready var parent: Node3D = get_parent() as Node3D

func _process(_delta: float) -> void:
  target = Globals.player_car
  parent.look_at(target.global_position, Vector3.UP, true)
