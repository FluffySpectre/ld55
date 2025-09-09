extends Control

@export var point_counter_label: Label

# Called when the node enters the scene tree for the first time.
func _ready():
  GameManager.instance.distance_changed.connect(on_distance_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass

func on_distance_changed(new_distance: float):
  point_counter_label.text = Utils.format_distance(new_distance)
