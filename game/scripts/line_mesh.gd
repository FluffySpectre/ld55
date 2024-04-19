extends Node3D

@export var body_a: Node3D
@export var body_b: Node3D
@export var color: Color = Color.WHITE_SMOKE

func _physics_process(delta):
	createLine(body_a.global_position, body_b.global_position, color)

func createLine(pos1: Vector3, pos2: Vector3, color = Color.WHITE_SMOKE):
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color

	return await final_cleanup(mesh_instance)

func final_cleanup(mesh_instance: MeshInstance3D):
	get_tree().get_root().add_child(mesh_instance)
	await get_tree().physics_frame
	mesh_instance.queue_free()
