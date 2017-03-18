tool
extends Node

export(int) var lats = 10 setget lats_set,lats_get
export(int) var lons = 10 setget lons_set,lons_get
export(float) var radius = 1 setget radius_set,radius_get
export(bool) var add_uv = true setget add_uv_set,add_uv_get
onready var sphere = get_node("rb/sp")
onready var collShape = get_node("rb/coll")
onready var gravityArea = get_node("rb/Area/gravityArea")
onready var camera = get_camera()

signal signal_camera_ready(planet_camera)

func lats_set(newvalue):
	lats=newvalue
	redraw_geometry(lats, lons, radius, add_uv)

func lats_get():
	return lats # getter must return a value

func lons_set(newvalue):
	lons=newvalue
	redraw_geometry(lats, lons, radius, add_uv)

func lons_get():
	return lons # getter must return a value

func radius_set(newvalue):
	radius=newvalue
	redraw_geometry(lats, lons, radius, add_uv)

func radius_get():
	return radius # getter must return a value

func add_uv_set(newvalue):
	add_uv=newvalue
	redraw_geometry(lats, lons, radius, add_uv)

func add_uv_get():
	return add_uv # getter must return a value

func _ready():
	redraw_geometry(lats, lons, radius, add_uv)
	self.add_to_group("celestial_body")

func redraw_geometry(vlats, vlons, vradius, vadd_uv):
	if (sphere != null):
		sphere.clear()
		sphere.begin(VS.PRIMITIVE_TRIANGLE_STRIP,null)
		sphere.add_sphere(vlats, vlons, vradius, vadd_uv)
		sphere.end()
		if(collShape != null):
			collShape.get_shape().set_radius(vradius)
		if(gravityArea != null):
			gravityArea.get_shape().set_radius(vradius * 10)
		get_node("rb/planetaryCamera").set_translation(Vector3(0, 0, radius * 3))
			
func get_camera():
	return get_node("rb/planetaryCamera")
	