class_name Health extends Node

@export var health: int = 100
@export var max_health: int = 100
@export var heal_amount: int = 10

signal on_health_changed()
signal died

var is_invincible = false
var heal_interval = 1.0
var heal_timer = 0.0
var cooldown_timer = 0.0
var heal_cooldown = 2.0

func _process(delta):
  if health >= max_health:
    heal_timer = 0.0
    return
  
  cooldown_timer += delta
  if cooldown_timer > heal_cooldown:
    heal_timer += delta
    if heal_timer > heal_interval:
      add_health(heal_amount)
      heal_timer = 0.0

func apply_damage(damage: int):
  if is_invincible:
    return
  
  var old_health = health
  var new_health = health - damage
  if new_health < 0:
    new_health = 0
    
  if old_health > 0 && new_health == 0:
    died.emit()
  
  health = new_health
  cooldown_timer = 0.0
  
  if old_health != new_health:
    on_health_changed.emit()
    #print("Health updated: ", health)

func add_health(amount: int):
  health += amount
  health = min(health, max_health)
  on_health_changed.emit()

func revive():
  health = max_health
  on_health_changed.emit()
