extends BaseEntity

@onready var hand_mag: float

func _init() -> void:
	super()

func _ready() -> void:
	super()
	
	var handpos: Vector2 = $Hand.position
	hand_mag = handpos.length()
	$GunSet.position = handpos
	
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
	var mouse_pos := get_global_mouse_position()
	var theta: float = gunset.get_angle_to(mouse_pos)
	
	gunset.position = Vector2(hand_mag * cos(theta), hand_mag * sin(theta))
	gunset.rotation = -theta
		# What the fuck is going on
	
	# TODO: Update direction the player sprite is facing based on cursor pos

	return
