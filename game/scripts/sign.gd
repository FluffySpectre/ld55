extends Node3D

@export_multiline var texts: Array[String]

@onready var label: Label3D = $Label3D

# Called when the node enters the scene tree for the first time.
func _ready():
  var random_text = texts[randi_range(0, texts.size() - 1)]
  label.text = random_text
