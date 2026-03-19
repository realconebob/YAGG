extends BaseEntity

func _init() -> void:
	super()

func _physics_process(delta: float) -> void:
	var up := Input.is_action_pressed(&"move_up")
	var lf := Input.is_action_pressed(&"move_left")
	var rt := Input.is_action_pressed(&"move_right")
	var dw := Input.is_action_pressed(&"move_down")
	var temp_accel := Vector2.ZERO
	var accelr := accel_rate
	if !accelr:
		assert(false, "accelr is unset") # why!?!?!?!?!?!?
	
	if dw: 
		print("down")
		temp_accel = Vector2(0, accelr.y)
	
	if up:
		print("up") 
		temp_accel = Vector2(0, -accelr.y)
	
	if rt: 
		print("right")
		temp_accel = Vector2(accelr.x, 0)
		print(temp_accel)
	
	if lf: 
		print("left")
		temp_accel = Vector2(-accelr.x, 0)
	print(temp_accel)
	
	set_accel(get_global_mouse_position() - position) # confirmation that I'm not going insane
	super._physics_process(delta) # god damn it godot you suck
	
	point_to_cursor()
	return
	
func point_to_cursor() -> void:
	var mouse_pos := get_global_mouse_position()
	
	# TODO: This will be replaced with the gun
	$Line2D.look_at(mouse_pos)
	
	# TODO: Update direction the player sprite is facing based on cursor pos
	
	return
