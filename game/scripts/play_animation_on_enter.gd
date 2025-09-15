class_name PlayAnimationOnEnter extends Node

@export var animation_player: AnimationPlayer
@export var animation_name: String = ""
@export var trigger_once: bool = false

var triggered: bool = false

func _ready() -> void:
  var area = get_parent() as Area3D
  area.body_entered.connect(on_body_entered)

func on_body_entered(body: Node3D) -> void:
  if body != Globals.player_car:
    return
    
  if trigger_once && triggered:
    return
    
  animation_player.play(animation_name)
  triggered = true
