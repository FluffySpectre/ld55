extends Control

@export var point_counter_label: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.instance.score_changed.connect(on_score_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_score_changed(new_score: int):
	point_counter_label.text = str(new_score)
