extends BaseEntity

@onready var gunset: GunSet = GunSet.new()
@onready var hand_mag: float

func _ready() -> void:
	set_max_move_speed(12000)
	add_child(gunset)
	
	var handpos: Vector2 = $Hand.position
	hand_mag = handpos.length()
	
	return

func _physics_process(delta: float) -> void:
	var dir := Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	set_accel((get_accel() / 2) + (dir * accel_rate))
	
	do_movement(delta)
	handle_inputs()
	point_to_cursor()
	return

func handle_inputs() -> void:
	if Input.is_action_just_pressed(&"select_gun1"): gunset.select_gun(0)
	if Input.is_action_just_pressed(&"select_gun2"): gunset.select_gun(1)
	if Input.is_action_just_pressed(&"select_gun3"): gunset.select_gun(2)
	if Input.is_action_just_pressed(&"select_gun4"): gunset.select_gun(3)
	if Input.is_action_just_pressed(&"select_gun5"): gunset.select_gun(4)
	if Input.is_action_just_pressed(&"cycle_up"): gunset.select_gun(gunset.get_gun_index() + 1)
	if Input.is_action_just_pressed(&"cycle_down"): gunset.select_gun(gunset.get_gun_index() - 1)
	
	return

func point_to_cursor() -> void:
	var cur_gun: BaseGun = gunset.get_cur_gun()
	var barrel_end: Node2D = cur_gun.get_barrel()
	
	var mouse_pos: Vector2 = get_global_mouse_position()
	var pointing_vec: Vector2 = mouse_pos - self.global_position
	var angle: float = pointing_vec.normalized().angle()
	
	gunset.global_rotation = angle
	gunset.position.x = 25 * cos(angle - self.global_rotation)
	gunset.position.y = 25 * sin(angle - self.global_rotation)

	if Input.is_action_pressed(&"shoot"):
		cur_gun.set_target(mouse_pos)
		cur_gun.set_bullet_pos(barrel_end.global_position)
		gunset.fire()

	return

func get_gunset() -> GunSet:
	return gunset
	
func get_type() -> String:
	return "Player"
