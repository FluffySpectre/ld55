extends FogVolume

# Called when the node enters the scene tree for the first time.
func _ready():
	if GameManager.instance.game_state == GameManager.GameState.IN_GAME:
		if Globals.fog_density < 1.0:
			Globals.fog_density += 0.1
			material.set_shader_parameter("density", Globals.fog_density * 0.8)
			GameManager.instance.world_environment.environment.volumetric_fog_density = minf(0.04 + Globals.fog_density * 0.06, 0.06)
	else:
		Globals.fog_density = 0.0
		material.set_shader_parameter("density", Globals.fog_density * 0.8)
		GameManager.instance.world_environment.environment.volumetric_fog_density = 0.04
