extends BaseGun

const bullet_scene := preload("res://guns/bullet.tscn")

@onready var handle: Node2D = $Handle
@onready var barrel: Node2D = $BarrelEnd

func fire() -> void:
	super()

func make_bullets(t: Vector2, p: Vector2, o: Vector2) -> Array[BaseEntity]:
	var res: Array[BaseEntity] = []
	var bullet: BaseEntity = bullet_scene.instantiate()
	
	bullet.scale = Vector2.ONE * 0.5
	
	#bullet.set_max_speed(5000)
	#bullet.set_acc((t - p).normalized() * 10000)
	#bullet.global_position = p
	#bullet.look_at(target)
	
	var pointing := (t - p).normalized()
	var angle := pointing.angle() if !o else o.angle()
	
	bullet.set_acc(10000 * Vector2(cos(angle), sin(angle)))
	bullet.global_position = p
	#bullet.global_rotation = 
	res.append(bullet)
	
	return res

func get_handle() -> Node2D:
	return handle
	
func get_barrel() -> Node2D:
	return barrel
