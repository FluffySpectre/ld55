extends Area3D

enum PickupType {
	RuneYellow
}

@export var pickup_type: PickupType

# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(on_area_entered)

func on_area_entered(body: CollisionObject3D):
	if Globals.player_car != body.get_parent():
		return
	
	pickup(Globals.player_car)
	get_parent().queue_free()
	
func pickup(interactor):
	var health = interactor.get_node("Health") as Health
	if health:
		health.add_health(10)
	
	# 
	GameManager.instance.pickup_picked_up.emit(pickup_type)
