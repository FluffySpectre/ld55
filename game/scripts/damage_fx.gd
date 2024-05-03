extends Node

@export var car_body: MeshInstance3D

var health: Health

func _ready():
	health = get_node("../Health") as Health
	health.on_health_changed.connect(on_health_changed)

func on_health_changed():
	car_body.material_overlay.albedo_color.a = 1.0 - (float(health.health) / float(health.max_health))
