tool
extends Spatial

#CelestialBody properties
export(bool) var is_star = false setget is_star_set
export(float) var radius = 1 setget radius_set
export(Color) var star_emit_color = Color(1, 1, 1) setget emit_color_set
export(Texture) var texture = null setget texture_set

#CelestialBody variables
onready var material_ove = FixedMaterial.new() #load("res://scenes/StarSystemBodies/body_material.tres").duplicate(true)
onready var rigid = self.get_node("rb")
onready var sphere = self.get_node("rb/sp")
onready var light = self.get_node("rb/OmniLight")
onready var collShape = self.get_node("rb/coll")
onready var gravityArea = self.get_node("rb/Area")
onready var gravityShape = self.get_node("rb/Area/grav")
onready var camera = self.get_camera()
onready var body_label = get_node("Label")

func is_star_set(newvalue):
	is_star = newvalue
	redraw_geometry()

func radius_set(newvalue):
	radius=newvalue
	redraw_geometry()

func texture_set(newvalue):
	texture = newvalue
	redraw_geometry()

func emit_color_set(newvalue):
	star_emit_color=newvalue
	redraw_geometry()

func _ready():
	redraw_geometry()
	self.add_to_group("celestial_bodies")

func redraw_geometry():
	if (sphere != null):
		var complexity = 20
		if self.radius > 1:
			complexity = 20 * self.radius
		sphere.clear()
		sphere.begin(VS.PRIMITIVE_TRIANGLE_STRIP,null)
		sphere.add_sphere(complexity, complexity, self.radius, 1)
		sphere.end()
		sphere.set_material_override(material_ove)
		if(rigid != null):
			reset_coll_shape(rigid)
		if(gravityArea != null):
			reset_coll_shape(gravityArea, true)
		camera.set_translation(Vector3(0, 0, radius * 3))
		if(!is_star && light != null && gravityArea != null):
			rigid.set_mode(RigidBody.MODE_RIGID)
#			gravityArea.set_space_override_mode(PhysicsServer.AREA_SPACE_OVERRIDE_COMBINE)
			light.set_enabled(false)
			material_ove.set_parameter(FixedMaterial.PARAM_GLOW, 0)
			material_ove.set_parameter(FixedMaterial.PARAM_EMISSION, Color(0, 0, 0))
		elif(light != null && gravityArea != null):
			rigid.set_mode(RigidBody.MODE_STATIC)
#			gravityArea.set_space_override_mode(PhysicsServer.AREA_SPACE_OVERRIDE_COMBINE)
			light.set_enabled(true)
			light.set_color(0, star_emit_color)
			material_ove.set_parameter(FixedMaterial.PARAM_GLOW, 1)
			material_ove.set_parameter(FixedMaterial.PARAM_EMISSION, star_emit_color)
		if(texture != null):
			material_ove.set_texture(FixedMaterial.PARAM_DIFFUSE, texture)
		
func reset_coll_shape(rigid_body, gravity = false):
	for i in range(0, rigid_body.get_shape_count()):
		rigid_body.set_shape(i, rigid_body.get_shape(i).duplicate(true))
		if(!gravity):
			rigid_body.get_shape(i).set_radius(self.radius)
		else:
			rigid_body.get_shape(i).set_radius(self.radius * 30)

func get_camera():
#	return get_node("rb/planetaryCamera")
	return get_node("rb/planetaryCamera")
	
func get_body_data():
	print(self.get_name())
	print(" body radius is " + str(self.radius))
	print(" collision radius is " + str(rigid.get_shape(0).get_radius()))#collShape.get_shape().get_radius()))
	print(" gravity radius is " + str(gravityArea.get_shape(0).get_radius()))#gravityShape.get_shape().get_radius()))
	pass
	
func star_color_by_agesize(size, age = 0):
	var yellow = Color("c7b245")
	var red = Color("c70000")
	var blue = Color("4b54a3")
	var star_colors = ColorArray([0, 1, 2])
	star_colors.insert(0, blue)
	star_colors.insert(1, yellow)
	star_colors.insert(2, red)
	
	var scale = round(size)
	var dif = size - scale
	star_emit_color = star_colors[scale]
	
	if(dif < 0):
		star_emit_color = star_emit_color.linear_interpolate(star_colors[scale - 1], abs(dif))
	else:
		star_emit_color = star_emit_color.linear_interpolate(star_colors[scale + 1], abs(dif))
	
	
	pass