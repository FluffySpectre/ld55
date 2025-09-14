class_name EmitParticlesImmediatly extends Node

@export var emit_on_ready: bool = true

@onready var particles: GPUParticles3D = get_parent() as GPUParticles3D

func _ready() -> void:
  if !emit_on_ready:
    return
  emit_particles()

func emit_particles() -> void:
  particles.restart()
  particles.emitting = true

func on_body_entered(_body: Node3D) -> void:
  emit_particles()
