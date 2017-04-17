extends "res://scripts/orbital_utilities.gd"


export(float) var ea = 0
export(float) var eccentricity = 0.0167
export(float) var mean_radius = 100.46435
export(float) var true_anom = 100.46435

func _ready():
#	ea = eccentric_anomaly_from_mean(eccentricity, mean_radius)
#	ea = eccentric_anomaly_from_true(eccentricity, true_anom)
#	ea = uvw_from_elements(0, 0.641, pi/2, pi)
	var position = Vector3(-6142438.668, 3492467.560, -25767.25680)
	var velocity = Vector3(505.8479685, 942.7809215, 7435.922231)
	var earth_mu = 3.986e14
	var aa = elements_from_state_vector(position, velocity, earth_mu)
	self.get_node("Label").set_text(str(aa.print_values()))
	
	
