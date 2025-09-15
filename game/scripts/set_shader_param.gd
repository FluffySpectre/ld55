@tool
class_name SetShaderParam extends Node

@export var param_name: String
@export var float_value: float : set = set_param

@onready var parent: Node = get_parent()

func set_param(value: Variant) -> void:
  if parent is CanvasItem:
    var mat = parent.material as ShaderMaterial
    if mat:
      mat.set_shader_parameter(param_name, value)
