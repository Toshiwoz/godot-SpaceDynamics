 tool
extends Spatial

var CelestialBody = preload("res://scenes/StarSystemBodies/celestial_body.tscn")
export(int) var num_planets = 5 setget num_planets_set
export(float) var star_size_factor = 1 setget star_size_factor_set
var star_system_seed = ""

func num_planets_set(newval):
	num_planets = newval
	gen_star_system(get_node("ss"), num_planets, star_size_factor)

func star_size_factor_set(newval):
	star_size_factor = newval
	gen_star_system(get_node("ss"), num_planets, star_size_factor)

func _ready():
	# obenin a tangent vector
	# earth.get_node("rb").apply_impulse(Vector3(0, 0, 0), Vector3(100, 0, 0))
	gen_star_system(get_node("ss"), num_planets, star_size_factor)


func gen_star_system(parent, num_planets, star_size_factor):
	if(parent):
		#clear all previous system
		for node in parent.get_children():
			parent.remove_child(node)
		#generate the system star
		var sun = CelestialBody.instance()
		sun.set_name("Sun")
		sun.is_star_set(true)
		sun.radius = 10 * star_size_factor
		sun.star_color_by_agesize(star_size_factor)
		parent.add_child(sun)
		
		#generate the planets
		var body_distance = 0
		for i in range(1, num_planets + 1):
			var planet = create_child_Body(sun, 1, body_distance, "Panet" + str(i))
			body_distance = planet.get_translation().x
			var moon = create_child_Body(planet, .25, 0, "Moon" + str(i))
#			body_distance = moon.get_translation().x
			
		print(star_system_seed)
		
#		var we = WorldEnvironment.new()
#		var env = load("res://scenes/StarSystemBodies/EnvironmentSpace.tres")
#		we.set_environment(env)
#		self.add_child(we)
		emit_signal("all_nodes_created")

func create_child_Body(parent_body, base_radius, accum_distance, name):
	var body_rand_fact = (randf() / 2) + .5
	var body_distance_rand_fact = (randf() / 2) + .5
	var body_radius = base_radius * body_rand_fact
	var body_distance = accum_distance + parent_body.radius + (body_distance_rand_fact * 10 * body_radius)
	var child_body = CelestialBody.instance()
	child_body.set_name(name)
	child_body.radius = body_radius
	parent_body.add_child(child_body)
	child_body.set_translation(Vector3(body_distance, 0, 0))
	star_system_seed += str(name, ", ", body_radius, ", ", body_distance, "//")
	return child_body

signal all_nodes_created()