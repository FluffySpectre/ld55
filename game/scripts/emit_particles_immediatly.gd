class_name EmitParticlesImmediatly extends Node

func _ready() -> void:
  var particles: GPUParticles3D = get_parent() as GPUParticles3D
  particles.restart()
  particles.emitting = true
