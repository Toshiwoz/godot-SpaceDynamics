extends Tree

onready var startree = get_tree().get_nodes_in_group("celestial_body")

func _ready():
	var tree = self
	var root = tree.create_item()	
	tree.set_hide_root(true)

	
	for body in startree:
		var staritem = tree.create_item(root)
		staritem.set_text(0, body.get_name())

func _on_Tree_item_selected():
	for So in startree:
		if(So.get_name() == self.get_selected().get_text(0)):
			if(So.get_camera() != null):
				print(So.radius_get())
				So.get_camera().set_translation(Vector3(0, 0, So.radius_get() * 2.5))
				So.get_camera().set_rotation(Vector3(0, 0, 0))
				So.get_camera().make_current()
				print("selected" + So.get_name() + "camera") 
				self.release_focus()
				break

