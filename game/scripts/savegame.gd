class_name Savegame extends RefCounted

func save() -> void:
  var config = ConfigFile.new()

  config.set_value("Save", "highscore", Globals.highscore)

  config.save("user://ritual_road.cfg")

func load() -> void:
  var config = ConfigFile.new()
  var err = config.load("user://ritual_road.cfg")
  if err != OK:
   return

  Globals.highscore = config.get_value("Save", "highscore") as float
