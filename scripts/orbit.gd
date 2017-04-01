extends ImmediateGeometry

var tr = Vector3(0, 0, 0)

func _ready():
	self.clear()
	set_fixed_process(true)
	
func _fixed_process(delta):
	self.begin(VS.PRIMITIVE_LINE_LOOP,null)
	self.add_vertex(tr)
	self.get_parent().get_translation()
	self.add_vertex(tr)
	self.end()
	