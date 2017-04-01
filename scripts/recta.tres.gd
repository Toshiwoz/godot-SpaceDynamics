extends ImmediateGeometry

func _ready():
  self.begin(VS.PRIMITIVE_LINE_STRIP,null)
  self.add_vertex(Vector3(2,2,0))
  self.add_vertex(Vector3(2,0,0))
  self.add_vertex(Vector3(-2,0,0))
  self.add_vertex(Vector3(-2,0,0))
  self.add_vertex(Vector3(-2,2,0))
  self.add_vertex(Vector3(2,0,0))
  self.end()