class_name SimpleAnimatedSprite extends Sprite3D

@export var fps: float = 2.0
@export var one_shoot = false
@export var one_shot_destroy_after = false

var frame_timer = 0.0

func _ready():
  frame = 0

func _process(delta):
  if one_shoot and frame == hframes - 1:
    if one_shot_destroy_after:
      get_parent().queue_free()
    return
  
  frame_timer += delta
  frame = (int(frame_timer * fps)) % hframes
