extends Tree

var startree
var treesize
onready var treesizeprev = self.get_size()

func _ready():
#	var tree = self
#	var root = tree.create_item()
#	tree.set_hide_root(true)
#	
#	for body in startree:
#		var staritem = tree.create_item(root)
#		staritem.set_text(0, body.get_name())
	pass

func _on_Tree_item_selected():
	for So in startree:
		if(So.get_name() == self.get_selected().get_text(0)):
			So.get_body_data()
			if(So.get_camera() != null):
				So.get_camera().set_translation(Vector3(0, 0, So.radius * 2.5))
				So.get_camera().set_rotation(Vector3(0, 0, 0))
				So.get_camera().make_current()
				print("selected " + So.get_name() + " camera") 
				self.release_focus()
				break



func _on_StarSystem_all_nodes_created():
	startree = get_tree().get_nodes_in_group("celestial_bodies")
	var tree = self
	var root = tree.create_item()
	tree.set_hide_root(true)
	
	for body in startree:
		var staritem = tree.create_item(root)
		staritem.set_text(0, body.get_name())


func _on_Button_pressed():
	var treesize = self.get_size()
	var newsize
	var buttonsize = get_node("Button").get_size()
	if treesize.y == buttonsize.y:
		newsize = treesizeprev
	else:
		newsize = Vector2(treesize.x, buttonsize.y)
	self.set_size(newsize)
