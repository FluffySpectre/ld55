class_name CameraAttentionTrigger extends Area3D

@export var attention_target: Node3D
@export var max_attention_distance_override: float = -1.0
@export var clear_attention_target_on_exit: bool = true
@export var trigger_once: bool = true
@export var disable_player_input: bool = true

var original_player_input_state: bool = true
var original_max_attention_distance: float = -1.0
var triggered: bool = false
var player_input: PlayerInput
var currently_switched: bool = false

func _ready():  
  monitorable = false
  
  if !visible:
    monitoring = false
    return
  
  body_entered.connect(on_body_entered)
  body_exited.connect(on_body_exited)
  
  if Globals.player_car:
    player_input = Globals.player_car.get_node("PlayerInput") as PlayerInput

func on_body_entered(body: Node3D):
  if Globals.player_car != body:
    return
  
  if trigger_once && triggered:
    return
    
  set_attention_target()

func on_body_exited(body: Node3D):
  if Globals.player_car != body:
    return
  
  if clear_attention_target_on_exit && currently_switched:
    reset_attention_target()

func set_attention_target():
  triggered = true
  currently_switched = true
  
  if disable_player_input && player_input:
    original_player_input_state = player_input.controllable
    player_input.controllable = false
  
  if max_attention_distance_override >= 0:
    original_max_attention_distance = Globals.camera_controller.max_attention_distance
    Globals.camera_controller.max_attention_distance = max_attention_distance_override
  
  Globals.camera_controller.attention_target = attention_target

func reset_attention_target():
  Globals.camera_controller.attention_target = null
  
  if max_attention_distance_override >= 0:
    Globals.camera_controller.max_attention_distance = original_max_attention_distance
  
  # Restore player input
  if disable_player_input && player_input:
    player_input.controllable = original_player_input_state
  
  currently_switched = false
