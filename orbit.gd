extends ImmediateGeometry

func _ready():
	self.clear()
	set_fixed_process(true)
	
func _fixed_process(delta):
	var tr = get_node("../rb").get_translation()
	print(tr.x, " - ", tr.y, " - ", tr.z)
	self.begin(VS.PRIMITIVE_LINE_LOOP,null)
	self.add_vertex(tr)
	self.end()
	