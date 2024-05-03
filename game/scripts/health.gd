class_name Health extends Node

@export var health: int = 100
@export var max_health: int = 100

signal on_health_changed()

func apply_damage(damage: int):
	health -= damage
	if health < 0:
		health = 0
	on_health_changed.emit()

func revive():
	health = max_health
	on_health_changed.emit()
