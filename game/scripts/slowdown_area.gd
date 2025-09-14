class_name SlowdownArea extends Area3D

@export_range(0.0, 1.0, 0.05) var slowdown_factor: float = 0.5

var original_max_speed: float

func _ready() -> void:
  monitorable = false
  
  body_entered.connect(on_body_entered)
  body_exited.connect(on_body_exited)

func on_body_entered(body: Node3D) -> void:
  if body != Globals.player_car:
    return
  
  original_max_speed = Globals.player_car.max_speed
  Globals.player_car.max_speed *= slowdown_factor

func on_body_exited(body: Node3D) -> void:
  if body != Globals.player_car:
    return
  
  Globals.player_car.max_speed = original_max_speed
