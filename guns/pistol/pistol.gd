extends BaseGun

const bullet_scene := preload("res://guns/bullet.tscn")

@onready var handle: Node2D = $Handle
@onready var barrel: Node2D = $BarrelEnd

func _ready() -> void:
	cost = 0

func make_bullets(t: Vector2, p: Vector2, o: Vector2) -> Array[BaseEntity]:
	var res: Array[BaseEntity] = []
	var bullet: BaseEntity = bullet_scene.instantiate()
	
	bullet.scale = Vector2.ONE * 0.5
	
	var pointing := (t - p).normalized()
	var angle := pointing.angle() if !o else o.angle()
	
	bullet.accel = 10000 * Vector2(cos(angle), sin(angle))
	bullet.global_position = p
	res.append(bullet)
	
	return res

func get_handle() -> Node2D:
	return handle
	
func get_barrel() -> Node2D:
	return barrel
