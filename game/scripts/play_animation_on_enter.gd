class_name PlayAnimationOnEnter extends Node

@export var animation_player: AnimationPlayer
@export var animation_name: String = ""

func _ready() -> void:
  var area = get_parent() as Area3D
  area.body_entered.connect(on_body_entered)

func on_body_entered(body: Node3D) -> void:
  if body != Globals.player_car:
    return
  animation_player.play(animation_name)
