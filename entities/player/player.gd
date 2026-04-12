extends BaseEntity

var cash: float = 100:
	set(n): cash = max(0, n)

@onready var gunset: GunManager = GunManager.new():
	get: return gunset

func _ready() -> void:
	max_speed = 12000
	add_child(gunset)

func _physics_process(delta: float) -> void:
	var dir := Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	accel = ((accel / 2) + (dir * 4000))
	super(delta)
	
	if Input.is_action_just_pressed(&"select_gun1"): gunset.gunidx = 0
	if Input.is_action_just_pressed(&"select_gun2"): gunset.gunidx = 1
	if Input.is_action_just_pressed(&"select_gun3"): gunset.gunidx = 2
	if Input.is_action_just_pressed(&"select_gun4"): gunset.gunidx = 3
	if Input.is_action_just_pressed(&"select_gun5"): gunset.gunidx = 4
	if Input.is_action_just_pressed(&"cycle_up"): gunset.gunidx += 1
	if Input.is_action_just_pressed(&"cycle_down"): gunset.gunidx -= 1
	
	var mouse_pos: Vector2 = get_global_mouse_position()
	var pointing_vec: Vector2 = (mouse_pos - self.global_position) as Vector2
	var angle: float = pointing_vec.normalized().angle()
	
	gunset.global_rotation = angle
	gunset.position.x = 50 * cos(angle - self.global_rotation)
	gunset.position.y = 50 * sin(angle - self.global_rotation)

	if Input.is_action_pressed(&"shoot"):
		var gun := gunset.get_current_gun()
		gun.target = get_global_mouse_position()
		gun.bpos = gun.get_barrel().global_position
		gun.pointing_angle = pointing_vec
		if gunset.fire(cash):
			cash -= gunset.get_current_gun().cost

func get_type() -> String:
	return "Player"
