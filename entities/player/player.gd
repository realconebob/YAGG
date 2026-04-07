extends BaseEntity

@onready var gunset: GunManager = GunManager.new():
	get: return gunset

func _init() -> void:
	base_type = "Player"

func _ready() -> void:
	max_speed = 12000
	add_child(gunset)

func _physics_process(delta: float) -> void:
	var dir := Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	set_acc((get_acc() / 2) + (dir * 4000))
	super(delta)
	
	if Input.is_action_just_pressed(&"select_gun1"): gunset.set_gun_index(0)
	if Input.is_action_just_pressed(&"select_gun2"): gunset.set_gun_index(1)
	if Input.is_action_just_pressed(&"select_gun3"): gunset.set_gun_index(2)
	if Input.is_action_just_pressed(&"select_gun4"): gunset.set_gun_index(3)
	if Input.is_action_just_pressed(&"select_gun5"): gunset.set_gun_index(4)
	if Input.is_action_just_pressed(&"cycle_up"): gunset.set_gun_index(gunset.get_gun_index() + 1)
	if Input.is_action_just_pressed(&"cycle_down"): gunset.set_gun_index(gunset.get_gun_index() - 1)
	
	var mouse_pos: Vector2 = get_global_mouse_position()
	var pointing_vec: Vector2 = (mouse_pos - self.global_position) as Vector2
	var angle: float = pointing_vec.normalized().angle()
	
	gunset.global_rotation = angle
	gunset.position.x = 50 * cos(angle - self.global_rotation)
	gunset.position.y = 50 * sin(angle - self.global_rotation)

	if Input.is_action_pressed(&"shoot"):
		var gun := gunset.get_current_gun()
		gun.set_target(get_global_mouse_position())
		gun.set_bullet_position(gun.get_barrel().global_position)
		gun.set_pointing(pointing_vec)
		gunset.fire()
		
	if Input.is_action_just_pressed(&"reload"):
		print("tried to reload")
		gunset.get_current_gun().reload()

## @deprecated: Implemented by Godot getter/setter syntax
func get_gunset() -> GunManager:
	return gunset

## @deprecated: Implemented by Godot getter/setter syntax
func get_type() -> String:
	return "Player"
