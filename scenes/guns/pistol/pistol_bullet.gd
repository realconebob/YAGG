extends BaseEntity

const pbul_mms: float = 10000
const pbul_acr: float = 10000
const pbul_dmp: float = 0

func _init() -> void:
	super(pbul_mms, Vector2.ZERO, pbul_acr, pbul_dmp, false, 5, 5, true)
	return

func _ready() -> void:
	$Sprite.play(&"default")
	return

func _physics_process(delta: float) -> void:
	exec_movement(delta)
	pass
