class_name Utils

static func format_distance(distance_meters: float) -> String:
  if distance_meters < 1000.0:
    return str(int(distance_meters)) + "m"
  else:
    var distance_km: float = distance_meters / 1000.0
    return str("%.1f" % distance_km) + "km"
