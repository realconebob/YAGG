extends BaseEntity

@onready var hand_mag: float

func _init() -> void:
	super()

func _ready() -> void:
	super()
	
	var handpos: Vector2 = $Hand.position
	hand_mag = handpos.length()
	#$GunSet.position = handpos
	
	return

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

	set_accel(dir.normalized() * accel_rate)
	do_movement(delta)

	point_to_cursor()
	return

func point_to_cursor() -> void:
	var gunset := $GunSet
	var cur_gun: BaseGun = gunset.get_cur_gun()
	var barrel_end: Node2D = cur_gun.get_barrel_end() # For later
	
	var mouse_pos: Vector2 = get_global_mouse_position()
	var pointing_vec: Vector2 = (mouse_pos - self.global_position) as Vector2
	var angle: float = pointing_vec.normalized().angle()
	
	gunset.global_rotation = angle
	gunset.position.x = 25 * cos(angle - self.global_rotation)
	gunset.position.y = 25 * sin(angle - self.global_rotation)
	
	# TODO: Include the hand_hold offset from the current gun

	# TODO: Update direction the player sprite is facing based on cursor pos

	return
