extends Camera

export(float, 1, 100) var max_Speed = 100
export(float, 0, 1, 0.01) var accel = .1

# internal variables
var yaw = 0
var pitch = 0
var view_sensitivity = .1
var speed = 0
var middlebutton_pressed = false
var dir = "n"
var parent_node = get_parent()

func _ready():
	set_fixed_process(true)
	set_process_input(true)

	pass

func _input(event):
	dir = "n"
	if event.type == InputEvent.MOUSE_MOTION && middlebutton_pressed:
		yaw = fmod(yaw - event.relative_x * view_sensitivity, 360)
		pitch = max(min(pitch - event.relative_y * view_sensitivity, 180),-180)
		set_rotation(Vector3(deg2rad(pitch), deg2rad(yaw), 0))
	elif event.type == InputEvent.MOUSE_BUTTON:
		middlebutton_pressed = event.button_index == 3 && event.pressed
	elif event.is_action_pressed("ui_focus_next"):
		var navcam = self

func _fixed_process(delta):
	var vp = self.get_viewport()
	var curr_pos = get_translation()
	var proy_dir = project_ray_normal(vp.get_rect().size / 2)
	var left_dir = proy_dir.rotated(self.get_translation(), 1)
	speed += accel;
	var nr_speed = proy_dir.normalized()
	if (speed) < max_Speed : 
		nr_speed = (proy_dir.normalized() * speed)
	
	if Input.is_action_pressed("move_up"):
		set_translation(curr_pos + nr_speed)
	elif Input.is_action_pressed("move_down"):
		set_translation(curr_pos - nr_speed)
	elif Input.is_action_pressed("ui_left"):
		set_translation(left_dir)
		
		
	else:
		speed = 0
		
