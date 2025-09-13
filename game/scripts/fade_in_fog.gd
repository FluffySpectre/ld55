extends FogVolume

@export var fade_curve: Curve

static var fade_value = 0.0
static var street_part = 0

# Called when the node enters the scene tree for the first time.
func _ready():
  if !GameManager.instance:
    return
  
  if GameManager.instance.game_state == GameManager.GameState.IN_GAME:
    if Globals.fog_density < 1.0:
      street_part += 1
      #if street_part <= 6:
        #return
      
      fade_value += 0.1
      Globals.fog_density = fade_curve.sample(fade_value)
      print("Setting fog density: " + str(Globals.fog_density) + " - Part: " + str(street_part))
      
      material.set_shader_parameter("density", Globals.fog_density * 0.8)
      GameManager.instance.world_environment.environment.volumetric_fog_density = minf(0.04 + Globals.fog_density * 0.06, 0.06)
  else:
    fade_value = 0.0
    street_part = 0
    Globals.fog_density = 0.0
    material.set_shader_parameter("density", Globals.fog_density * 0.8)
    GameManager.instance.world_environment.environment.volumetric_fog_density = 0.04
