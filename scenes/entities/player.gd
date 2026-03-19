extends BaseEntity

func _init() -> void:
	super()

func _physics_process(delta: float) -> void:
	var up := Input.is_action_pressed(&"move_up")
	var lf := Input.is_action_pressed(&"move_left")
	var rt := Input.is_action_pressed(&"move_right")
	var dw := Input.is_action_pressed(&"move_down")
	
	var dir := Vector2.ZERO
	if up: dir += Vector2(0, -1)
	if lf: dir += Vector2(-1, 0)
	if rt: dir += Vector2(1, 0)
	if dw: dir += Vector2(0, 1)

	set_accel(dir * accel_rate)
	super._physics_process(delta)
	
	point_to_cursor()
	return
	
func point_to_cursor() -> void:
	var mouse_pos := get_global_mouse_position()
	
	# TODO: This will be replaced with the gun
	$Line2D.look_at(mouse_pos)
	
	# TODO: Update direction the player sprite is facing based on cursor pos
	
	return
