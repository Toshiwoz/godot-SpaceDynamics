extends Spatial


func _ready():
	var earth = get_node("earth")
	var camera = get_node("Camera")
	# obenin a tangent vector
	earth.get_node("rb").apply_impulse(Vector3(0, 0, 0), Vector3(10, 0, 0))