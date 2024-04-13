class_name DestroyAfterTime extends Node

@export var delay = 3.0
@export var destroy_parent_instead = false

var timer = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if timer > delay:
		do_destroy()

func do_destroy():
	if destroy_parent_instead:
		get_parent().queue_free()
	else:
		queue_free()
