extends Line2D

@onready var mouse_pos: Vector2
@onready var pointing_vec: Vector2
@onready var angle: float

func _ready() -> void:
	mouse_pos = Vector2.ZERO
	pointing_vec = Vector2.ZERO
	angle = 0.0
	global_scale = Vector2.ONE
	return

func _physics_process(_delta: float) -> void:
	mouse_pos = get_global_mouse_position()
	pointing_vec = (mouse_pos - self.global_position) as Vector2
	angle = pointing_vec.normalized().angle()
	
	self.global_rotation = angle
	self.points[1].x = pointing_vec.length() * cos(angle - self.global_rotation)
	self.points[1].y = pointing_vec.length() * sin(angle - self.global_rotation)
	
	$Distance.text = "%0.2f" % sqrt(((mouse_pos.x - self.global_position.x) ** 2) + ((mouse_pos.y - self.global_position.y) ** 2))
