class_name PlaySoundOnEnter extends Node

@export var audio_stream_player: AudioStreamPlayer3D
@export var audio_stream: AudioStream
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
  
  if audio_stream:
    audio_stream_player.stream = audio_stream
  audio_stream_player.play()
  
  triggered = true
